#!/usr/bin/env sh

while true; do
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}' | tr -d '.'
    sleep 1
done
