#!/bin/bash
MODEL=$1
RUNDATE=$2
HOURSEACHRUN=$3
OPTIONS=$4


INTERSECTIONSPATHREMOTE=$DDS_CACHE_PATH/$MODEL/netcdf/intersections.db

RISICOPATH=/opt/risico/$MODEL
# check if the model directory exists
if [ ! -d "$RISICOPATH" ]; then
	echo "Model directory $RISICOPATH does not exist."
	exit 1
fi

cd $RISICOPATH

# cleanup
rm $RISICOPATH/AGGRCACHE/* || true
rm $RISICOPATH/OUTPUT*/* || true

# execution
java 	-cp "$LIBPATH/jar/*:$LIBPATH/Runner.jar" -Djava.library.path="$LIBPATH:/usr/lib/jni" \
		Experience.Services.ModelRunner.ModelRunner \
		$OPTIONS -overwrite -InputDir $RISICOPATH/INPUT -path $RISICOPATH -hoursEachRun $HOURSEACHRUN -exe $EXECUTABLE \
		-conf configuration.yml -future $*


# copy intersections.db to local
# generate aggregations
risico_aggregation_with_raster  --config $RISICOPATH/aggregation-config.yaml  --intersection-cache $RISICOPATH/intersections.db
# copy intersections.db back to remote
cp $RISICOPATH/intersections.db $INTERSECTIONSPATHREMOTE

# output copy
copy_nc_files.sh $MODEL $RUNDATE
copy_nc_aggregation_cache.sh $MODEL $RUNDATE $RISICOPATH/AGGRCACHE/

