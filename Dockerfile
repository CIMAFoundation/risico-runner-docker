FROM openjdk:8-jre

RUN apt-get update && \
    apt-get install -y rsync && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/risico/lib/jar

ENV DDS_OUTPUT_PATH=/opt/dds/output
ENV DDS_CACHE_PATH=/opt/dds/cache
ENV LIBPATH=/opt/risico/lib/
ENV EXECUTABLE=risico-2023_v1.0.1

ENV PATH=$PATH:$LIBPATH

# Set working directory
WORKDIR /opt/risico

# Copy all the files from the lib directory to the container
COPY lib/ lib/

# Make the run script executable
RUN chmod +x ./lib/run.sh
RUN chmod +x ./lib/${EXECUTABLE}
RUN chmod +x /opt/risico/lib/risico_aggregation_with_raster
RUN chmod +x /opt/risico/lib/copy_nc_files.sh
RUN chmod +x /opt/risico/lib/copy_nc_aggregation_cache.sh

# run the application with passed arguments
ENTRYPOINT ["./lib/run.sh"]

