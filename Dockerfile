FROM debian:jessie

MAINTAINER Datadog <package@datadoghq.com>

ENV DOCKER_DD_AGENT yes
ENV AGENT_VERSION 1:5.8.0-1

# Install the Agent
RUN echo "deb http://apt.datadoghq.com/ stable main" > /etc/apt/sources.list.d/datadog.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7A7DA52 \
 && apt-get update \
 && apt-get install --no-install-recommends -y datadog-agent="${AGENT_VERSION}" \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure the Agent
# 1. Listen to statsd from other containers
# 2. Turn syslog off
RUN mv /etc/dd-agent/datadog.conf.example /etc/dd-agent/datadog.conf \
 && sed -i -e"s/^.*non_local_traffic:.*$/non_local_traffic: yes/" /etc/dd-agent/datadog.conf \
 && sed -i -e"s/^.*log_to_syslog:.*$/log_to_syslog: no/" /etc/dd-agent/datadog.conf

COPY entrypoint.sh /entrypoint.sh

# Expose DogStatsD port
EXPOSE 8125/udp

# Set proper permissions to allow running as a non-root user
RUN chmod g+w /etc/dd-agent/datadog.conf
RUN chmod -R g+w /var/log/datadog
RUN chmod g+w /etc/dd-agent

ENTRYPOINT ["/entrypoint.sh"]

USER 1001

CMD /opt/datadog-agent/embedded/bin/python /opt/datadog-agent/agent/dogstatsd.py
