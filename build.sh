#!/bin/sh
# Copy some resources from host data dir to this host dir
cp /home/realtime/data/indonesia.sqlite .
cp /home/realtime/data/population.tif .
cp /home/realtime/data/population.keywords .

docker.io build -t AIFDR/inasafe-realtime .
# Clean this dir again

rm indonesia.sqlite population.tif population.keywords
