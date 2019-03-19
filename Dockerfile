FROM phusion/baseimage:0.11
LABEL maintainer="Stefan Fritsch <stefan.fritsch@stat-up.com>"

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    TERM=xterm

RUN echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen
    
RUN update-locale

LABEL build="2019-03-19"
RUN apt-get update \
    && apt-get upgrade -y -o Dpkg::Options::="--force-confold" \
    && apt-get install -y -o Dpkg::Options::="--force-confold" iputils-ping nano wget procps unzip zip curl\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/sbin/my_init"]
