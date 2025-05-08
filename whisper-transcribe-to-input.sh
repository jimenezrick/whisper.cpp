#!/bin/bash

set -e

: ${EMACS_BUFFER:='*ChatGPT*'}
SOX_EFFECT='silence 1 0.2 2% 1 1.0 2%'

# Can also use: ffmpeg -f alsa -i default -ar 16000 -y /tmp/whisper.wav
uxterm -r -e bash -c "env AUDIODRIVER=alsa rec --rate 16k --type wav /tmp/whisper.wav $SOX_EFFECT"
curl -s 127.0.0.1:8080/inference -H "Content-Type: multipart/form-data" -F file="@/tmp/whisper.wav" -F response_format="text" >/tmp/whisper.txt

if [[ $1 = emacsclient ]]
then
	emacsclient -e "(with-current-buffer \"${EMACS_BUFFER}\" (insert \"$(tr "\n" " " </tmp/whisper.txt | sed 's/^[ \t]*//;s/[ \t]*$//')\"))"
elif [[ $1 = xdotool ]]
then
	xdotool type --delay=0 "$(tr "\n" " " </tmp/whisper.txt | sed 's/^[ \t]*//;s/[ \t]*$//')"
else
	cat /tmp/whisper.txt | tr "\n" " " | sed 's/^[ \t]*//;s/[ \t]*$//'
	echo
fi
