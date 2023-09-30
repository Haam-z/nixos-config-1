#!/usr/bin/env sh

while [ true ]; do
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print$2}' | awk -F'.' '{print $1$2}'
    sleep 1
done
