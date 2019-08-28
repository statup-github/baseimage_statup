#!/bin/bash
## Add users based on a file with random passwords
## File syntax:
##
## <1: username>:<2: uid (=gid)>:<3: passwd hash from mkpasswd -m sha-512>:<4: homedir>:<5: full name>:<6: shell>:<7: additional,groups,comma,separated>
##
## Everything but the username is optional
##
## e.g.
## me.myself:::/home/someone:Myers::root,wheel
##
# get newusers file from first arg on cmd line or default to 'newusers.txt'
nf="${1:-/secrets/users}"

# get existing usernames and uids.
names="^($(getent passwd | cut -d: -f1 | paste -sd'|'))$"
 uids="^($(getent passwd | cut -d: -f3 | paste -sd'|'))$"

yesterday=$(date -d yesterday +%Y-%m-%d)
# temp file for passwords
# tf=$(mktemp) ; chmod 600 "$tf"

# If the UID is not specified apply UIDs in the 2000001... range
i=2000000

while IFS=: read u uid pw homedir gecos shell addgroups; do
    ((i++))
    uid="${uid:-$i}"   
    gid="$uid"
    # generate a random password for each user..    
    pw="${pw:-$(makepasswd --chars=32 | mkpasswd -s -m sha-512)}"
    shell="${shell:-/bin/bash}"
    homedir="${homedir:-/home/$u}"

    groupadd -g "$gid" "$u"
    useradd  -m -d "$homedir" -c "$gecos" \
             -u "$uid" -g "$gid" -p "$pw" -s "$shell" "$u"
    
    if [[ ! -z "$addgroups" ]]; then
       usermod -a -G ${addgroups} "$u"
    fi

done < <(awk -F: '$1 !~ names && $2 !~ uids' names="$names" uids="$uids" "$nf")

# uncomment to warn about users not created:
#echo Users not created because the username or uid already existed: >&2
#awk -F: '$1 ~ names || $2 ~ uids' names="$names" uids="$uids" "$nf" >&2    
