FROM openjdk:8-jre

RUN apt-get update && apt-get install -y --no-install-recommends \
    rsync && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/risico

ENV DDS_OUTPUT_PATH=/opt/dds/output \
    DDS_CACHE_PATH=/opt/dds/cache \
    LIBPATH=/opt/risico/lib/ \
    EXECUTABLE=risico-2023_v1.0.1 \
    PATH=$PATH:/opt/risico/lib/

COPY lib/ lib/

RUN chmod +x ./lib/run.sh \
    ./lib/${EXECUTABLE} \
    ./lib/risico_aggregation_with_raster \
    ./lib/copy_nc_files.sh \
    ./lib/copy_nc_aggregation_cache.sh

ENTRYPOINT ["./lib/run.sh"]