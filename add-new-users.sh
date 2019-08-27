#!/bin/bash -e

## Add users
if [ ! -z "$SSH_USERS" ]; then
    mkdir -p /secrets
    touch /secrets/users
    chmod 0600 /secrets/users
    echo -e "${SSH_USERS}" > /secrets/users
fi

if [[ -r /secrets/users ]]; then
  /usr/bin/add-users /secrets/users
fi

if [[ -r /secrets/ssh-users && ! -r /secrets/users ]]; then
  /usr/bin/add-users /secrets/ssh-users
fi
