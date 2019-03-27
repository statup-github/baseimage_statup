FROM phusion/baseimage:0.11
MAINTAINER Stefan Fritsch <stefan.fritsch@stat-up.com>

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    TERM=xterm

RUN echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen
    
RUN update-locale

COPY add-users.sh /usr/bin/add-users
RUN chmod a+x /usr/bin/add-users

COPY enable_ssh.sh /etc/my_init.d/enable-ssh.sh
RUN chmod u+x /etc/my_init.d/enable-ssh.sh

RUN apt-get update \
  && apt-get install -y --no-install-recommends unzip zip psmisc wget nano curl makepasswd \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/sbin/my_init"]
