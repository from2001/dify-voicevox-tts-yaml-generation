# What is this script?  
This script will generate [voicevox.yaml](https://github.com/uezo/dify-voicevox-tts/blob/main/voicevox/tts/voicevox.yaml) of [dify-voicevox-tts](https://github.com/uezo/dify-voicevox-tts) based on speakers information installed on Voicevox.

# Usage  

## Open the app
Open Voicevox or AivisSpeech application

## Generate yaml
```
# With Voicevox API
python generate_voicebox_yaml.py http://localhost:50021/speakers

## With AivisSpeech API
python generate_voicebox_yaml.py http://localhost:10101/speakers

```

## Copy the yaml file to dify directory
Replace the generated yaml with the [file](https://github.com/uezo/dify-voicevox-tts/blob/main/voicevox/tts/voicevox.yaml) in the dify-voicevox-tts directory.

# Links
[dify-voicevox-tts](https://github.com/uezo/dify-voicevox-tts)  
[VOICEVOX](https://voicevox.hiroshiba.jp/)  
[AivisSpeech](https://aivis-project.com/)  

