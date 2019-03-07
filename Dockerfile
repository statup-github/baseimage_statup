FROM phusion/baseimage:0.11

RUN apt-get update \
    && apt-get upgrade -y -o Dpkg::Options::="--force-confold" \
    && apt-get install -y -o Dpkg::Options::="--force-confold" iputils-ping nano wget procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
