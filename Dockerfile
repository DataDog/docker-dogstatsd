FROM debian:wheezy

MAINTAINER Benjamin Fernandes <benjamin@datadoghq.com>

ENV DEBIAN_FRONTEND noninteractive

# Add datadog repository
RUN echo "deb http://apt.datadoghq.com/ stable main" > /etc/apt/sources.list.d/datadog.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7A7DA52
RUN apt-get update

# Install Dogstatsd
RUN apt-get install datadog-agent -qq --no-install-recommends
# Fix missing dependency, should be removed soon
RUN apt-get install procps -qq --no-install-recommends


# Configure it
RUN mv /etc/dd-agent/datadog.conf.example /etc/dd-agent/datadog.conf
# Listen to statsd from other containers
RUN sed -i -e"s/^.*non_local_traffic:.*$/non_local_traffic: yes/" /etc/dd-agent/datadog.conf
# Turn off syslog
RUN sed -i -e"s/^.*log_to_syslog:.*$/log_to_syslog: no/" /etc/dd-agent/datadog.conf

# Use a startup script to setup configuration with environement variables
ADD run-dogstatsd.sh /usr/local/bin/run-dogstatsd.sh
RUN chmod +x /usr/local/bin/run-dogstatsd.sh

EXPOSE 8125/udp

CMD ["/usr/local/bin/run-dogstatsd.sh"]
