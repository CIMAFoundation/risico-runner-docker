# Docker image for RISICO runner

This repository implements a complete RISICO runner.
Build the container with 

```bash
docker build -t risico-runner .
```

The model files should be mounted in the `/opt/risico/$MODELNAME` directory inside the container.
The output data directory should be mounted in the `/opt/risico/output/$MODELNAME` directory inside the container.
Run the container with

```bash
docker run -it --rm \
    -v /path/to/risico/models_and_data/:/opt/risico \   
    risico-runner $MODELNAME $DATE $RUN_LENGTH_HOURS $OPTIONS
```
where:

- _/path/to/risico/models_and_data_ should be the path to the directory containing the RISICO model, archive directory and ancillary files (e.g. aggregation files). This directory will should be mounted to _/opt/risico_ inside the container. Relevant configuration files should point to _/opt/risico_
    - The directory structure should be as follows:
      ```
      /path/to/risico/models
      ├── RISICO2023        # the model directory with all the necessary data
      ├── RISICO...         # other models
      ├── archive           # the archive directory with the model output, the runner will 
      |   |                 # copy the output files here using the run date as subdirectory
      │   └── RISICO2023/netcdf/2025/07/09/0000
      └── shapefiles        # the directory with the shapefiles used by the model for the aggregation
      ```


- _DATE_ should be in the format `YYYYMMDD0000`.

- _RUN_LENGTH_HOURS_ should be an integer representing the number of hours to run the model.

- _OPTIONS_ should be a string with the options to pass to the model, e.g. `-hoursRes 1` (optional).

# Example usage
docker run  --platform="linux/amd64" -it --rm -v ./example:/opt/risico risico-runner RISICO2023 202506120000 72 "-hoursRes 1"
