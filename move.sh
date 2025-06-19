#!/bin/bash

GARBAGE=".mkv .avi .mpg .mp4 .divx" #### Add or remove extensions here
DOCS=".pdf"

for junk in $GARBAGE
do
    find /mnt/new/complete -name *$junk -type f -exec mv -v {} /mnt/new/videos \;
done

for junk in $DOCS
do
    find /mnt/new/complete -name *$junk -type f -exec mv -v {} /mnt/new/ebooks \
	 \;
done

