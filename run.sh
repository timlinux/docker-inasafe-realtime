#!/bin/sh

docker.io run --name="inasafe-realtime" \
-v /home/realtime/shakemaps-cache:/home/realtime/shakemaps-cache \
-v /home/realtime/shakemaps-extracted:/home/realtime/shakemaps-extracted \
-p 2222:22 \
-d -t AIFDR/inasafe-realtime:latest
