#!/usr/bin/env python3
# generate_voicevox_yaml.py
import sys
import requests
import yaml
import os

def main():
    if len(sys.argv) < 2:
        print("Usage: python generate_voicevox_yaml.py http://localhost:50021/speakers")
        sys.exit(1)

    api_url = sys.argv[1]

    # Attempt to get JSON data from the specified API endpoint
    try:
        response = requests.get(api_url, timeout=10)
        response.raise_for_status()  # Raise HTTPError if the response was unsuccessful
        data = response.json()       # 'data' is the JSON list from the API
    except requests.exceptions.RequestException as e:
        # Catch any request-related errors (ConnectionError, Timeout, HTTPError, etc.)
        print(f"Network error occurred: {e}")
        sys.exit(1)

    # Validate the API response format
    # 1) Check if it's a list
    # 2) Each element should be a dict that has at least a "styles" key which is a list
    if not isinstance(data, list) or not data:
        print("Error: The API response doesn't match the expected JSON structure (non-empty list is required).")
        sys.exit(1)

    for idx, speaker in enumerate(data):
        if not isinstance(speaker, dict):
            print(f"Error: The item at index {idx} is not a JSON object (dict).")
            sys.exit(1)
        if "styles" not in speaker or not isinstance(speaker["styles"], list):
            print(f"Error: The item at index {idx} does not contain the 'styles' list.")
            sys.exit(1)

    # Build a data structure for the YAML file
    # Use the first speaker's first style ID as default_voice if possible
    default_voice = str(data[0]["styles"][0]["id"]) if data and data[0].get("styles") else ""

    voices = []
    for speaker in data:
        speaker_name = speaker.get("name", "")
        styles = speaker.get("styles", [])
        for style in styles:
            style_name = style.get("name", "")
            style_id = style.get("id", "")
            voices.append(
                {
                    "mode": str(style_id),
                    "name": f"{speaker_name} - {style_name}",
                    "language": ["ja-JP"]
                }
            )

    # Construct the final YAML data
    yaml_data = {
        "model": "voicevox",
        "model_type": "tts",
        "model_properties": {
            "default_voice": default_voice,
            "voices": voices,
            "word_limit": 40,
            "audio_type": "wav",
            "max_workers": 5
        },
        "pricing": {
            "input": "0.0",
            "output": "0",
            "unit": "0.0",
            "currency": "USD"
        }
    }

    # Output to a file named "voicevox.yaml"
    filename = "voicevox.yaml"
    with open(filename, "w", encoding="utf-8") as f:
        yaml.dump(yaml_data, f, allow_unicode=True)

    # Print the absolute path of the output file
    print("Yaml generation succeeded.")
    print(os.path.abspath(filename))

if __name__ == "__main__":
    main()
