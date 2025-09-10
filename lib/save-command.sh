#!/bin/bash
OUTPATH=$1
shift # shift the first argument away
echo "saving '$*' to $OUTPATH"
echo $* > $OUTPATH