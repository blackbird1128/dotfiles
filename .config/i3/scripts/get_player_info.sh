#!/bin/bash

info=$(playerctl metadata --format "{{ artist }} - {{ title }}" 2>/dev/null)

if $(playerctl status 2>/dev/null | grep -q "Playing"); then
    status="▶"
elif $(playerctl status 2>/dev/null | grep -q "Paused"); then
    status="⏸"
else
    status="⏹"
fi

artist=$(playerctl metadata artist)
title=$(playerctl metadata title)

current=$(date -d@$(playerctl position --format "{{ position }}" | awk '{print $1/1000000}') -u +'%M:%S')

# Get total length of the track in seconds
total_length_microseconds=$(playerctl metadata mpris:length)
total_length_seconds=$(echo "$total_length_microseconds" | awk '{printf "%d\n", $1 / 1000000}')
total=$(date -u -d@"$total_length_seconds" +'%M:%S')

info=" $status $artist - $title ($current/$total)"


if [[ $total == "00:00" ]]; then
    info=" $status $artist - $title"
fi

echo $info
# Check if the formatted string contains a valid artist and title before printing
if [[ "$info" != " -  (00:00/00:00)" ]]; then
    echo "$info"
fi

