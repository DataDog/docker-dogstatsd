# DogStatsD Dockerfile

This repository is meant to build the base image for a DogStatsD container. You will have to use the resulting image to configure and run DogStatD.


## Quick Start

Create a `Dockerfile` to set your API key.

```
FROM datadog/docker-dogstatsd

# Set your API key
RUN sed -i -e"s/^.*api_key:.*$/api_key: YOUR_API_KEY/" /etc/dd-agent/datadog.conf
```

Build it.

`docker build .`

Then run it.

`docker run -d -name dogstatsd dogstatsd_image_id`


## Link to other containers

Your other containers will probably want to send datas to the DogStatsD container. For that, you will need to add a `--link` option to your run command.

```
docker run  --name my_container           \
            --all_your_flags              \
            --link dd-agent:my_container  \
            my_image_id
```

Then you will have DogStatsd address and port accessible from your environnement in `DOGSTATSD_PORT_8125_UDP_ADDR` and `DOGSTATSD_PORT_8125_UDP_PORT`.


## Administration

### Logs

DogStatsD logs are available through the `logs` command.

`docker logs dogstatsd`

You can set logging to DEBUG verbosity by adding to your `Dockerfile`:

```
RUN sed -i -e"s/^.*log_level:.*$/log_level: DEBUG/" /etc/dd-agent/datadog.conf
```

### DogStatsD from host

If you want to send datas to DogStatsD from your host, you have to bind the port. For that, add the option `-p 8125:8125/udp` to the Docker DogStatsD run command.

`docker run -d -name dogstatsd -p 8125:8125/udp dogstatsd_image_id`




More documentation: [DogStatsD guide](http://docs.datadoghq.com/guides/dogstatsd/)
