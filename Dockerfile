FROM openjdk:8-jre

RUN apt-get update && apt-get install -y --no-install-recommends \
    rsync && \
    rm -rf /var/lib/apt/lists/*

ENV ARCHIVE_PATH=/opt/risico/archive \
    LIBPATH=/opt/lib \
    EXECUTABLE=risico-2023_v1.0.1 \
    PATH=$PATH:/opt/lib/

WORKDIR /opt/
COPY lib/ lib/
COPY lib/jar lib/jar

RUN chmod +x ./lib/run.sh \
    ./lib/${EXECUTABLE} \
    ./lib/risico_aggregation_with_raster \
    ./lib/copy_nc_files.sh \
    ./lib/copy_nc_aggregation_cache.sh

RUN test -f /opt/lib/run.sh || (echo "run.sh not found!" && exit 1)
#ENTRYPOINT ["/opt/lib/run.sh"]
ENTRYPOINT ["bash"]