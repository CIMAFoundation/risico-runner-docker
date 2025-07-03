#!/bin/bash
MODEL=$1
RUNDATE=$2

declare -x RISICOPATH=/opt/risico/$MODEL
declare -x RUNDATEDIR=${RUNDATE:0:4}/${RUNDATE:4:2}/${RUNDATE:6:2}/${RUNDATE:8:4}
declare -x NCDFPATH=$DDS_OUTPUT_PATH/$MODEL/netcdf/$RUNDATEDIR/

echo "Copying netcdf files for model $MODEL to $NCDFPATH"

# check if the model directory exists
if [ ! -d "$RISICOPATH/OUTPUT-NC" ]; then
    echo "Model output directory $RISICOPATH/OUTPUT-NC does not exist."
    exit 1
fi

# check if the output directory exists
if [ ! -d "$NCDFPATH" ]; then
    echo "Output directory $NCDFPATH does not exist. Creating it."
    mkdir -p $NCDFPATH
fi

# copy netcdf files
echo "Copying netcdf files from $RISICOPATH/OUTPUT-NC to $NCDFPATH"

rsync -av $RISICOPATH/OUTPUT-NC/* $NCDFPATH
