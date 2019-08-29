#!/bin/bash -e

if [ ! -z "$SSH_ENABLE" ] && [ "${SSH_ENABLE,,}" = "true" ]; then
    
    ## Regenerate host keys if possible
    if [[ (! -e /etc/ssh/ssh_host_rsa_key || -w /etc/ssh/ssh_host_rsa_key) \
       && (! -e /etc/ssh/ssh_host_dsa_key || -w /etc/ssh/ssh_host_dsa_key) ]]; then
        yes y | ssh-keygen -P "" -t rsa -f /etc/ssh/ssh_host_rsa_key
        yes y | ssh-keygen -P "" -t dsa -f /etc/ssh/ssh_host_dsa_key
        echo "regenerated host keys" > /root/regenerated_host_keys
    fi
    
    ## Accept certificate
    sed -i 's;^AuthorizedPrincipalsFile.*;# AuthorizedPrincipalsFile %h/.ssh/authorized_principals;g' /etc/ssh/sshd_config
    sed -i 's;^TrustedUserCAKeys.*;# TrustedUserCAKeys;g' /etc/ssh/sshd_config
    echo "TrustedUserCAKeys /etc/ssh/ssh_trusted_ca.pub" >> /etc/ssh/sshd_config
    
    ## Allow user to set the SSH-Port (useful if the container uses the host network)
    SSH_PORT="${SSH_PORT:-22}"
    sed -i "s/#?Port.*/Port ${SSH_PORT}/g" /etc/ssh/sshd_config
    
    ## Enable service
    rm -f /etc/service/sshd/down

fi
