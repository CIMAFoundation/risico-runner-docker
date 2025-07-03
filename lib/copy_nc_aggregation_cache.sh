#!/bin/bash
MODEL=$1
RUNDATE=$2
CACHEDIR=$3

declare -x RUNDATEDIR=${RUNDATE:0:4}/${RUNDATE:4:2}/${RUNDATE:6:2}/${RUNDATE:8:4}
declare -x NCDFCACHEPATH=$DDS_OUTPUT_PATH/$MODEL/netcdf/$RUNDATEDIR/CACHE/

echo "Copying netcdf aggregation cache for model $MODEL to $NCDFCACHEPATH"
# check if the model directory exists
if [ ! -d "$CACHEDIR" ]; then
    echo "Cache directory $CACHEDIR does not exist."
    exit 1
fi

# check if the output directory exists
if [ ! -d "$NCDFCACHEPATH" ]; then
    echo "Output cache directory $NCDFCACHEPATH does not exist. Creating it."
    mkdir -p $NCDFCACHEPATH
fi
# copy netcdf aggregation cache files
echo "Copying netcdf aggregation cache files from $CACHEDIR to $NCDFCACHEPATH"
rsync -av $CACHEDIR $NCDFCACHEPATH
