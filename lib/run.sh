#!/bin/bash
echo "Running ModelRunner with args: $@"

MODEL=$1
RUNDATE=$2
HOURSEACHRUN=$3
OPTIONS=$4

# check if archivepath is existent
if [ ! -d "$ARCHIVE_PATH" ]; then
    echo "Archive path $ARCHIVE_PATH does not exist."
    exit 1
fi

INTERSECTIONSPATHREMOTE=$ARCHIVE_PATH/$MODEL/netcdf/intersections.db
RISICOPATH=/opt/risico/$MODEL
ARGFILE=$RISICOPATH/args.txt

# check if the model directory exists
if [ ! -d "$RISICOPATH" ]; then
	echo "Model directory $RISICOPATH does not exist."
	exit 1
fi

cd $RISICOPATH

# cleanup
rm $RISICOPATH/AGGRCACHE/* || true
rm $RISICOPATH/OUTPUT*/* || true
# clean argfile
rm $ARGFILE || true
# clean input directory
find $RISICOPATH/INPUT -mindepth 1 -type d -exec rm -rf {} +


# extract data from dds
java 	-cp "$LIBPATH/jar/*:$LIBPATH/Runner.jar" -Djava.library.path="$LIBPATH:/usr/lib/jni" \
		Experience.Services.ModelRunner.ModelRunner \
		-date $RUNDATE \
		-overwrite \
		-InputDir $RISICOPATH/INPUT \
		-path $RISICOPATH \
		-hoursEachRun $HOURSEACHRUN \
		-exe "save-command.sh $ARGFILE" \
		-conf configuration.yml \
		-future \
		-keepInputFiles \
		$OPTIONS \
		$*

# read args from file and execute the model runs
xargs -a $ARGFILE -n 3 $EXECUTABLE
if [ $? -ne 0 ]; then
	echo "Error: $EXECUTABLE execution failed."
	exit 1
fi

# copy intersections.db to local
# generate aggregations
risico_aggregation_with_raster --config $RISICOPATH/aggregation-config.yml --intersection-cache $RISICOPATH/intersections.db
if [ $? -ne 0 ]; then
	echo "Error: Aggregation command failed."
	exit 1
fi

# copy intersections.db back to remote
cp $RISICOPATH/intersections.db $INTERSECTIONSPATHREMOTE
# output copy
copy_nc_files.sh $MODEL $RUNDATE
copy_nc_aggregation_cache.sh $MODEL $RUNDATE $RISICOPATH/AGGRCACHE/

rm $ARGFILE || true
find $RISICOPATH/INPUT -mindepth 1 -type d -exec rm -rf {} +
