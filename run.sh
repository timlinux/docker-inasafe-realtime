#!/bin/sh

# This if for development so that we can ssh into it
REALTIME_DIR=/home/realtime
INASAFE_REALTIME_IMAGE=docker-inasafe-realtime

# Kill previous container
docker.io kill inasafe-realtime
docker.io rm inasafe-realtime

docker.io run --name="inasafe-realtime" \
-p 2222:22 \
-v ${REALTIME_DIR}/shakemaps-cache:${REALTIME_DIR}/shakemaps-cache \
-v ${REALTIME_DIR}/shakemaps-extracted:${REALTIME_DIR}/shakemaps-extracted \
-d -t AIFDR/${INASAFE_REALTIME_IMAGE}:latest
