#!/bin/bash -   
#title          :Download.sh
#description    :This script is used for downloading .ts files from internet using wget command.
#author         :Ivan Zagar
#date           :20190218
#version        :1.0.0  
#usage          :./Download.sh
#notes          :       
#bash_version   :4.4.12(3)-release
#============================================================================

# Base stream url:
# This link can be found in Network tab (Developer tools). 
# Under network tab find a row with format "media_w1299204677_b1980000_2.ts"
# Right click on that row and select Copy -> Copy link address
# Paste that link address below

StreamUrl='https://585ddcf1f3493.streamlock.net/ava_archive04/_definst_/2018/10/16/174569118.smil/media_w1299204677_b1980000_2.ts'

echo "Current user is: $USER"

# Export video to desktop
VideoOutputURL='C:\Users\'$USER'\Desktop\OutputVideo'
mkdir -p $VideoOutputURL
cd $VideoOutputURL

# Parameter Substitution - Delete longest match of substring from front of $string.
# Remove from $StreamUrl the longest part of $Pattern that matches the front end of $var. (get only last /media_w2066169975_b1980000_2.ts)
# e.g. media_w1621956579_b1920000_2.ts'
StreamUrlPrefix="${StreamUrl##*/}"
# e.g. media_w1621956579_b1920000'
StreamUrlSufix="${StreamUrlPrefix%_*}"
# e.g. 'https://585ddcf1f3493.streamlock.net/ava_archive05/_definst_/2019/02/12/174595055.smil/media_w1621956579_b1920000'
StreamUrlBase="${StreamUrl%_*}"
echo "Stream url base: $StreamUrlBase"

# Download all .ts videos using wget tool
counter=0
WgetReturnStatus=0

while [ $WgetReturnStatus -eq 0 ]
    do
    wget $StreamUrlBase'_'$counter.ts
    WgetReturnStatus=$?
    
    if [[ $WgetReturnStatus -ne 0 ]]; then
		# End of stream sources
		echo "End of stream sources. Aborting successfully."
        break
    fi
    echo $StreamUrlSufix'_'$counter.ts | tr " " "\n" >> tslist 
    counter=$((counter+1))
done

# Redirect stdout to a file using COMMAND_OUTPUT >>
# Read what is inside of file and concat it to OutputVideo
while read line; 
    do cat $line >> OutputVideo.mp4; 
done < tslist

# Delete all media files and .ts list file
rm -rf media* tslist

# Open file explorer with exporter video
explorer.exe $VideoOutputURL