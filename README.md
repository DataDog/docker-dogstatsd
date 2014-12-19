# DogStatsD Dockerfile

This repository is meant to build the image for a DogStatsD container.

** This image is deprecated. Please run [DogStatsD from docker-dd-agent](https://github.com/DataDog/docker-dd-agent/tree/new-usage-methods#dogstatsd) instead.**

## Quick Start

This image is ready-to-go, you just need to set your hostname and API_KEY in the environment.

```
docker run -d --name dogstatsd -h `hostname` -e API_KEY=apikey_3 datadog/docker-dogstatsd
```

## Link to other containers

Your other containers will probably want to send datas to the DogStatsD container. For that, you will need to add a `--link` option to your run command.

```
docker run  --name my_container           \
            --all_your_flags              \
            --link dogstatsd:dogstatsd \
            my_image_id
```

Then you will have DogStatsd address and port accessible from your environment in `DOGSTATSD_PORT_8125_UDP_ADDR` and `DOGSTATSD_PORT_8125_UDP_PORT`.


## Administration

You can refer to [docker-dd-agent documentation](https://github.com/DataDog/docker-dd-agent/).
