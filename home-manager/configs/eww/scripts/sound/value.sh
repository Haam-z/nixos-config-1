#!/usr/bin/env sh

while true; do
    wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print $2}' | tr -d '.'
    sleep 1
done
