#!/usr/bin/env bash

#download and parse the page
embed_url=$(curl -s "$1" | pup 'iframe.player-iframe attr{src}')
json_url=$(curl -s "$embed_url" |grep "www.rtvs.sk/json/archive5f.json"|cut -d'"' -f2|sed -e 's/\/\///g')
m3u8_url=$(curl -s "$json_url" |jq -r '.clip|.sources[]|select(.type=="application/x-mpegurl")|.src')

#download m3u8
curl -s $m3u8_url > m3u8.txt

#extract mid band
midband_url=$(cat m3u8.txt|grep "http"|head -n 1)

ffmpeg -i "$midband_url" -c copy -bsf:a aac_adtstoasc $2