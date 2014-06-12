# DogStatsD Dockerfile

This repository is meant to build the image for a DogStatsD container.


## Quick Start

The default image is ready-to-go, you just need to set your hostname and API_KEY in the environment.

```
docker run -d --name dogstatsd -h `hostname` -e API_KEY=apikey_3 datadog/docker-dogstatsd
```

## Link to other containers

Your other containers will probably want to send datas to the DogStatsD container. For that, you will need to add a `--link` option to your run command.

```
docker run  --name my_container           \
            --all_your_flags              \
            --link dogstatsd:my_container \
            my_image_id
```

Then you will have DogStatsd address and port accessible from your environnement in `DOGSTATSD_PORT_8125_UDP_ADDR` and `DOGSTATSD_PORT_8125_UDP_PORT`.


## Administration

### Logs

DogStatsD logs are available through the `logs` command.

`docker logs dogstatsd`


### DogStatsD from host

If you want to send datas to DogStatsD from your host, you have to bind the port. For that, add the option `-p 8125:8125/udp` to the Docker DogStatsD run command.


More documentation:

* [DogStatsD guide](http://docs.datadoghq.com/guides/dogstatsd/)
* [Datadog Agent Docker containers](https://github.com/DataDog/dd-agent/wiki/Docker-Containers)
