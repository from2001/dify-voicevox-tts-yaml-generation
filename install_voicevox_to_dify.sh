#!/bin/bash

# Container name of the DIFY API
CONTAINER_NAME="docker-api-1"

# Check if the CONTAINER_NAME container is running.
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Container $CONTAINER_NAME is running."
else
    echo "Container $CONTAINER_NAME is not running. Please start the container first."
    exit 1
fi

# If the first argument is specified, assign it to SPEAKER_API_ENDPOINT
if [ -n "$1" ]; then
    SPEAKER_API_ENDPOINT=$1
fi

# Prompt the user to enter the URL of the Voicevox Speaker API endpoint if not already set
if [ -z "$SPEAKER_API_ENDPOINT" ]; then
    read -p "Please enter the URL of the Voicevox Speaker API endpoint (e.g., http://localhost:50021/speakers). If you want to skip, just press Enter: " SPEAKER_API_ENDPOINT
fi

# Clone dify-voicevox-tts
rm -rf dify-voicevox-tts
git clone -q https://github.com/uezo/dify-voicevox-tts.git

# If SPEAKER_API_ENDPOINT is specified, generate and copy voicevox.yaml
if [ -n "$SPEAKER_API_ENDPOINT" ]; then
    # generate_voicevox_yaml.py を実行
    python generate_voicevox_yaml.py $SPEAKER_API_ENDPOINT

    # Copy generated voicevox.yaml to dify-voicevox-tts/voicevox/tts/voicevox.yaml
    cp voicevox.yaml dify-voicevox-tts/voicevox/tts/voicevox.yaml

    # Count the number of languages in voicevox.yaml
    NUM_LANGUAGES=$(grep -c "language:" voicevox.yaml)

    # Output the number of languages
    echo ""
    echo "$NUM_LANGUAGES voice models have been detected."
    echo ""
fi

# Copy files to the container
docker cp dify-voicevox-tts/voicevox docker-api-1:/app/api/core/model_runtime/model_providers

# apt-get update inside the container
echo "Updating package lists inside the container..."
docker exec -it $CONTAINER_NAME apt-get update -qq

# Install ffmpeg inside the container
echo "Installing ffmpeg inside the container..."
docker exec -it $CONTAINER_NAME apt-get install -y -qq ffmpeg

# Commit changes to the container
echo "Committing changes to the container..."
docker commit $CONTAINER_NAME $CONTAINER_NAME

# Print the installation completion message
echo ""
echo "Voicevox has been installed to Dify successfully."

# Restart the container
echo ""
read -p "Do you want to restart the container? (y/n): " RESTART_CONTAINER
if [ "$RESTART_CONTAINER" == "y" ]; then
    echo "Restarting the container..."
    docker restart $CONTAINER_NAME
else
    echo "Container restart skipped."
fi

# Clean up
rm -rf dify-voicevox-tts
