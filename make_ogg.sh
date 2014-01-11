#!/bin/bash
album=$(basename "$1")
artist=$(basename "$(dirname "$1")")
mkdir -p "$artist"/"$album"
for f in "$1"/*.flac; do
	output="$artist"/"$album"/$(basename "$f" .flac).ogg
	
	ffmpeg -y -i "$f" -c:a libvorbis -aq 8 "$output"
done
