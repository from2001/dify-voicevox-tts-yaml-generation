# Notice

This is not working with Dify 1.0.x  
I am developing Dify plugin version of the feature.  

# What is this script?  

The script installs [dify-voicevox-tts](https://github.com/uezo/dify-voicevox-tts) into Dify with the list of voice models supported by Voicevox or AivisSpeech API.

# Usage  

## Preparations
 - Open Voicevox or AivisSpeech application.  
 - Make sure that Dify containers are running with Docker.  

## Automatic setup (Recommended)
```sh
# Add executable permission
chmod +x install_voicevox_to_dify.sh

# Run the install script
./install_voicevox_to_dify.sh

# Run the install script with API endpoint
./install_voicevox_to_dify.sh http://localhost:50021/speakers
```

The script automatically performs the following steps:
 - Clones the dify-voicevox-tts repository.
 - Generates the voice list file (voicevox.yaml) for dify-voicevox-tts based on the speakers information installed on Voicevox or AivisSpeech.
 - Overwrites the existing voicevox.yaml file.
 - Installs the required modules (e.g., ffmpeg) in the `docker-api-1` container.
 - Installs dify-voicevox-tts in the `docker-api-1` container.
 - Commits the changes to the `docker-api-1` container.
 - Restarts the `docker-api-1` container.
 

## Manual setup

### Generate yaml
```
# With Voicevox API
python generate_voicebox_yaml.py http://localhost:50021/speakers

## With AivisSpeech API
python generate_voicebox_yaml.py http://localhost:10101/speakers
```

### Copy the yaml file to dify directory
Replace the generated yaml with the [file](https://github.com/uezo/dify-voicevox-tts/blob/main/voicevox/tts/voicevox.yaml) in the dify-voicevox-tts directory.

# Links
[dify](https://github.com/langgenius/dify)  
[dify-voicevox-tts](https://github.com/uezo/dify-voicevox-tts)  
[VOICEVOX](https://voicevox.hiroshiba.jp/)  
[AivisSpeech](https://aivis-project.com/)  

