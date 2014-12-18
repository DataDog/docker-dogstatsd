FROM debian:wheezy

MAINTAINER Datadog <package@datadoghq.com>

ENV DOCKER_DD_AGENT yes
ENV AGENT_VERSION 1:5.1.1-546

# Install the Agent
RUN echo "deb http://apt.datadoghq.com/ stable main" > /etc/apt/sources.list.d/datadog.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7A7DA52 \
 && apt-get update \
 && apt-get install -y datadog-agent="${AGENT_VERSION}"

# Configure the Agent
# 1. Listen to statsd from other containers
# 2. Turn syslog off
RUN mv /etc/dd-agent/datadog.conf.example /etc/dd-agent/datadog.conf \
 && sed -i -e"s/^.*non_local_traffic:.*$/non_local_traffic: yes/" /etc/dd-agent/datadog.conf \
 && sed -i -e"s/^.*log_to_syslog:.*$/log_to_syslog: no/" /etc/dd-agent/datadog.conf

COPY entrypoint.sh /entrypoint.sh

# Expose DogStatsD port
EXPOSE 8125/udp

ENTRYPOINT ["/entrypoint.sh"]
CMD ["dogstatsd"]
