#!/bin/sh

docker.io run --name="inasafe-realtime" \
-v /home/realtime/data/indonesia.sqlite:/dev/python/inasafe/realtime/fixtures/indonesia.sqlite \
-v /home/realtime/data/population.tif:/dev/python/inasafe/realtime/fixtures/exposure/population.tif \
-v /home/realtime/data/population.keywords:/dev/python/inasafe/realtime/fixtures/exposure/population.keywords \
-v /home/realtime/shakemaps-cache:/var/realtime/shakemaps-cache \
-v /home/realtime/shakemaps-extracted:/var/realtime/shakemaps-extracted \
-p 2222:22
-d -t AIFDR/inasafe-realtime:latest
