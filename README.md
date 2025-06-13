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
    -v /path/to/your/model:/opt/risico/$MODELNAME \
    -v /path/to/your/output:/opt/risico/output/$MODELNAME \
    
    risico-runner $MODELNAME $DATE $RUN_LENGTH_HOURS $OPTIONS
```

_DATE_ should be in the format `YYYYMMDD0000`.

_RUN_LENGTH_HOURS_ should be an integer representing the number of hours to run the model.

_OPTIONS_ should be a string with the options to pass to the model, e.g. `-hoursRes 1`.

# Example usage
docker run  --platform="linux/amd64" -it --rm -v ./example/RISICO2023:/opt/risico/RISICO2023 -v ./example:/opt/risico/output risico-runner RISICO2023 202506120000 72 "-hoursRes 1"
