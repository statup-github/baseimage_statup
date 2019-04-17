FROM phusion/baseimage:0.11
LABEL maintainer="Stefan Fritsch <stefan.fritsch@stat-up.com>"
LABEL build="2019-04-17"

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    TERM=xterm

RUN echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen
    
RUN update-locale

COPY add-users.sh /usr/bin/add-users
RUN chmod a+x /usr/bin/add-users

COPY enable-ssh.sh /etc/my_init.d/enable-ssh.sh
RUN chmod u+x /etc/my_init.d/enable-ssh.sh

RUN apt-get update \
  && apt-get upgrade -y -o Dpkg::Options::="--force-confold" \
  && apt-get install -y --no-install-recommends iputils-ping nano wget procps unzip zip curl makepasswd whois \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/sbin/my_init"]
