#!/bin/sh

# move files over to music directory
find . -mindepth 1 -maxdepth 1 -type d -and -not -path "./.*" -exec scp -r {} homelan:/mnt/backup/music/flac/ \; -exec rm -rf {} \;

rm -f *.wav
