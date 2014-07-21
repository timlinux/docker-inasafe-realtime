#!/bin/sh

REALTIME_DATA_DIR=/home/realtime/data
INASAFE_REALTIME_IMAGE=docker-inasafe-realtime
# Copy some resources from host data dir to this host dir
if [ -f "${REALTIME_DATA_DIR}/population.tif" ]
then
    cp ${REALTIME_DATA_DIR}/population.tif .
else
    wget -O ${REALTIME_DATA_DIR}/population.tif http://quake.linfiniti.com/population.tif
fi

if [ -f "${REALTIME_DATA_DIR}/population.keywords" ]
then
    cp ${REALTIME_DATA_DIR}/population.keywords .
else
    wget -O ${REALTIME_DATA_DIR}/population.keywords http://quake.linfiniti.com/population.keywords
fi

if [ -f "${REALTIME_DATA_DIR}/indonesia.sqlite" ]
then
    cp ${REALTIME_DATA_DIR}/indonesia.sqlite .
else
    wget -O ${REALTIME_DATA_DIR}/indonesia.sqlite http://quake.linfiniti.com/indonesia.sqlite
fi

docker.io build -t AIFDR/${INASAFE_REALTIME_IMAGE} .

# Clean this dir again
rm indonesia.sqlite population.tif population.keywords
