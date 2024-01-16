#!/usr/bin/env bash
#set -x
export IFS=$'\n'
#id of the program from url e.g. https://www.rtvs.sk/televizia/archiv/14280/40576 will be 14280
program_id=$1
#date from which to start archive crawling format yyyy-m e.g. 2012-4
start_date=$2
output_dir=$3
#prefix of output file
output_prefix=$4

current_date=$(date +'%Y-%-m')
base_url="https://www.rtvs.sk"

pc=0
while [[ $start_date != $current_date ]]; do
  
  echo "Date: $start_date"
  year=$(echo "$start_date" | cut -d'-' -f1)
  month=$(echo "$start_date" | cut -d'-' -f2)
  
  for prog in $(curl -s "${base_url}/json/snippet_archive_series_calendar.json?id=${program_id}&m=${start_date}"|jq -r '.snippets|."snippet-calendar-calendar"'|pup 'a attr{href}'|grep televizia); do
    ((pc++))
    echo "Program url: $prog"
    #download and parse the page
    embed_url=$(curl -s "${base_url}${prog}" | pup 'iframe.player-iframe attr{src}')
    json_url=$(curl -s "$embed_url" |grep "www.rtvs.sk/json/archive5f.json"|cut -d'"' -f2|sed -e 's/\/\///g')
    m3u8_url=$(curl -s "$json_url" |jq -r '.clip|.sources[]|select(.type=="application/x-mpegurl")|.src')

    #download m3u8
    curl -s $m3u8_url > m3u8.txt

    #extract mid band
    midband_url=$(cat m3u8.txt|grep "http"|head -n 1)

    ffmpeg -i "$midband_url" -c copy -bsf:a aac_adtstoasc "${output_dir}${output_prefix}-${pc}-${year}.mp4"
    sleep 30
  done

  if [ $month -eq 12 ]; then
      month=1
      pc=0
      ((year++))
  else
      ((month++))
  fi
  
  # Format the incremented date
  start_date="${year}-${month}"
done

