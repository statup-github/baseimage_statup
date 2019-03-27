#!/bin/sh

if [ ! -z "$SSH_ENABLE" ] && [ "${SSH_ENABLE,,}" = "true" ]; then

    ## Add users
    if [ ! -z "$SSH_USERS" ]; then
        echo -e "${SSH_USERS}" > /secrets/ssh-users
    fi
    chmod 0600 /secrets/ssh-users
    /usr/bin/add-users.sh /secrets/ssh-users
    
    ## Enable service
    rm -f /etc/service/sshd/down
    ssh-keygen -P "" -t dsa -f /etc/ssh/ssh_host_dsa_key
    
    ## Accept certificate
    sed -i 's;^AuthorizedPrincipalsFile.*;# AuthorizedPrincipalsFile %h/.ssh/authorized_principals;g' /etc/ssh/sshd_config
    sed -i 's;^TrustedUserCAKeys.*;# TrustedUserCAKeys;g' /etc/ssh/sshd_config
    echo "TrustedUserCAKeys /etc/ssh/ssh_trusted_ca.pub" >> /etc/ssh/sshd_config
fi
