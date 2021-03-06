#!/bin/bash

# get metadata.xml from musicbrainz
#discid=`./discid | grep "^DiscID" | sed "s/.* : //"`
#curl -s "https://musicbrainz.org/ws/2/discid/$discid?inc=artists+recordings" | xmlstarlet fo > metadata.xml

# show a list of releases
#grep \<event.* -o metadata.xml | nl -w 1 -s': '

# make user pick a release
pick=1
#echo "Enter your selection: "
#read pick

# build tags.txt
rm -f tags.txt
touch tags.txt
xml=metadata.xml
artist=$(xmlstarlet sel -N a="http://musicbrainz.org/ns/mmd-2.0#" -t -v '/a:metadata/a:disc/a:release-list/a:release['$pick']/a:artist-credit/a:name-credit/a:artist/a:name' $xml | perl -n -mHTML::Entities -e ' ; print HTML::Entities::decode_entities($_) ;' | sed "s/’/'/g" | sed "s/‐/-/g")
album=$(xmlstarlet sel -N a="http://musicbrainz.org/ns/mmd-2.0#" -t -v '/a:metadata/a:disc/a:release-list/a:release['$pick']/a:title' $xml | perl -n -mHTML::Entities -e ' ; print HTML::Entities::decode_entities($_) ;' | sed "s/’/'/g" | sed "s/‐/-/g")
year=$(xmlstarlet sel -N a="http://musicbrainz.org/ns/mmd-2.0#" -t -v '/a:metadata/a:disc/a:release-list/a:release['$pick']/a:date' $xml | egrep '[0-9]{4}' -o)
tracks=$(xmlstarlet sel -N a="http://musicbrainz.org/ns/mmd-2.0#" -t -v '/a:metadata/a:disc/a:release-list/a:release['$pick']/a:medium-list/a:medium['$pick']/a:track-list//a:track//a:title' $xml | perl -n -mHTML::Entities -e ' ; print HTML::Entities::decode_entities($_) ;' | sed "s/’/'/g" | sed "s/‐/-/g")

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

cat tags.txt
