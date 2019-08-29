FROM phusion/baseimage:0.11
LABEL maintainer="Stefan Fritsch <stefan.fritsch@stat-up.com>"

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    TERM=xterm

## French because data.table in R uses the French locale
## for parsing decimal comma entries.
RUN echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen
    
RUN update-locale

RUN rm -f /etc/ssh/ssh_host_*_key*
COPY ssh_trusted_ca.pub /etc/ssh/ssh_trusted_ca.pub

COPY add-users.sh /usr/bin/add-users
RUN chmod a+x /usr/bin/add-users

## Enable ssh with SSH_ENABLE=true
##
## Users can be passed to the container via environment variable SSH_USERS, 
## or the files /secrets/users (preferred) or /secrets/ssh-users (backwards compatibility)
##
## File syntax:
##
## <1: username>:<2: uid (=gid)>:<3: passwd hash from mkpasswd -m sha-512>:<4: homedir>:<5: full name>:<6: shell>:<7: additional,groups,comma,separated>
##
## Everything but the username is optional; the password is randomly generated if necessary
##
## e.g.
## me.myself:::/home/someone:Myers::root,wheel
COPY add-new-users.sh enable-ssh.sh 000_run_first.sh zzz_run_last.sh /etc/my_init.d/
RUN chmod u+x /etc/my_init.d/add-new-users.sh \
              /etc/my_init.d/enable-ssh.sh \
              /etc/my_init.d/000_run_first.sh \
              /etc/my_init.d/zzz_run_last.sh


RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && apt-get update \
  && apt-get upgrade -y -o Dpkg::Options::="--force-confold" \
  && apt-get install -y --no-install-recommends iputils-ping nano wget procps unzip zip curl makepasswd whois \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/sbin/my_init"]
