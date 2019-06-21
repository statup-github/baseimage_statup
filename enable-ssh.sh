#!/bin/bash

if [ ! -z "$SSH_ENABLE" ] && [ "${SSH_ENABLE,,}" = "true" ]; then

    ## Add users
    if [ ! -z "$SSH_USERS" ]; then
        mkdir -p /secrets
        touch /secrets/ssh-users
        chmod 0600 /secrets/ssh-users
        echo -e "${SSH_USERS}" > /secrets/ssh-users
    fi
    
    /usr/bin/add-users /secrets/ssh-users
    
    ## Enable service
    rm -f /etc/service/sshd/down
    if [[ ! -e /etc/ssh/ssh_host_rsa_key || -w /etc/ssh/ssh_host_rsa_key ]]; then
        yes y | ssh-keygen -P "" -t rsa -f /etc/ssh/ssh_host_rsa_key
    fi
    if [[ ! -e /etc/ssh/ssh_host_dsa_key || -w /etc/ssh/ssh_host_dsa_key ]]; then
        yes y | ssh-keygen -P "" -t dsa -f /etc/ssh/ssh_host_dsa_key
    fi
    
    ## Accept certificate
    sed -i 's;^AuthorizedPrincipalsFile.*;# AuthorizedPrincipalsFile %h/.ssh/authorized_principals;g' /etc/ssh/sshd_config
    sed -i 's;^TrustedUserCAKeys.*;# TrustedUserCAKeys;g' /etc/ssh/sshd_config
    echo "TrustedUserCAKeys /etc/ssh/ssh_trusted_ca.pub" >> /etc/ssh/sshd_config
fi
