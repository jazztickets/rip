#!/bin/bash
rm -f track00.cdda.wav

infile=tags.txt

year=$(grep ^YEAR= $infile | sed 's/YEAR=//g')
artist=$(grep ^ARTIST= $infile | sed 's/ARTIST=//g')
album=$(grep ^ALBUM= $infile | sed 's/ALBUM=//g')

clean_artist=${artist//[\<\>\"\/\\\|\*\:\?]/}
clean_album=${album//[\<\>\"\/\\\|\*\:\?]/}

mkdir -p "$clean_artist"/"$clean_album"
for f in *.wav; do
	pad_num=$(echo $f | grep '[0-9]\+' -o)
	num=$(echo $pad_num | sed -r 's|^0+||g')
	title=$(grep ^TRACK$pad_num= $infile | sed 's/.\+=//g')
	clean_title=${title//[\<\>\"\/\\\|\*\:\?]/}
	flac -8 -f -T "DATE=$year" -T "ARTIST=$artist" -T "ALBUM=$album" -T "TRACKNUMBER=$num" -T "TITLE=$title" $f -o "$clean_artist"/"$clean_album"/$pad_num\ -\ "$clean_title".flac 
done

