#!/bin/sh

# move files over to music directory
find . -mindepth 1 -maxdepth 1 -type d -and -not -path "./.*" -exec cp -r {} /media/backup/Music/FLAC/ \; -exec rm -rf {} \;

rm -f *.wav
