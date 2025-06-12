#!/bin/bash
MODEL=$1
RUNDATE=$2

declare -x RISICOPATH=/opt/risico/$MODEL
declare -x RUNDATEDIR=${RUNDATE:0:4}/${RUNDATE:4:2}/${RUNDATE:6:2}/${RUNDATE:8:4}
declare -x NCDFPATH=$DDS_OUTPUT_PATH/$MODEL/netcdf/$RUNDATEDIR/

mkdir -p $NCDFPATH
rsync -av -T /run/user/1001/ /opt/risico/$MODEL/OUTPUT-NC/* $NCDFPATH
