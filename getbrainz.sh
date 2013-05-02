#!/bin/bash

# get metadata.xml from musicbrainz
./discid | grep WS\ url | grep http.* -o | wget -i - -O - -q | xmlstarlet fo > metadata.xml

# show a list of releases
grep \<event.* -o metadata.xml | nl -w 1 -s': '

# make user pick a release
pick=1
echo "Enter your selection: "
read pick

# build tags.txt
rm -f tags.txt
touch tags.txt
xml=metadata.xml
artist=$(xmlstarlet sel -N a="http://musicbrainz.org/ns/mmd-1.0#" -t -v '/a:metadata/a:release-list/a:release['$pick']/a:artist/a:name' $xml | perl -n -mHTML::Entities -e ' ; print HTML::Entities::decode_entities($_) ;')
album=$(xmlstarlet sel -N a="http://musicbrainz.org/ns/mmd-1.0#" -t -v '/a:metadata/a:release-list/a:release['$pick']/a:title' $xml | perl -n -mHTML::Entities -e ' ; print HTML::Entities::decode_entities($_) ;')
year=$(xmlstarlet sel -N a="http://musicbrainz.org/ns/mmd-1.0#" -t -v '/a:metadata/a:release-list/a:release['$pick']/a:release-event-list/a:event/@date' $xml | egrep '[0-9]{4}' -o)
tracks=$(xmlstarlet sel -N a="http://musicbrainz.org/ns/mmd-1.0#" -t -v '/a:metadata/a:release-list/a:release['$pick']/a:track-list//a:track/a:title' $xml | perl -n -mHTML::Entities -e ' ; print HTML::Entities::decode_entities($_) ;')

# remove musicbrainz utf8 chars
album=${album/’/'}
album=${album/‐/-}
tracks=${tracks/’/'}
tracks=${tracks/‐/-}

echo "ARTIST=$artist" >> tags.txt
echo "ALBUM=$album" >> tags.txt
echo "YEAR=$year" >> tags.txt

# write tracks
i=1
IFS=$'\n'
for track in $tracks; do
	printf "TRACK%02d=%s\n" $i $track >> tags.txt
	i=$[i + 1]
done

