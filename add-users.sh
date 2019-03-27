#!/bin/bash
## Add users based on a file with random passwords
## File syntax:
##
## <username>:<uid and gid>:<passwd hash from mkpasswd -m sha-512>:<homedir>:<full name>:<shell>
##
## Everything but the username is optional
##
# get newusers file from first arg on cmd line or default to 'newusers.txt'
nf="${1:-newusers.txt}"

# get existing usernames and uids.
names="^($(getent passwd | cut -d: -f1 | paste -sd'|'))$"
 uids="^($(getent passwd | cut -d: -f3 | paste -sd'|'))$"

yesterday=$(date -d yesterday +%Y-%m-%d)
# temp file for passwords
# tf=$(mktemp) ; chmod 600 "$tf"

# If the UID is not specified apply UIDs in the 2000001... range
i=2000000

while IFS=: read u uid pw homedir gecos shell; do
    ((i++))
    uid="${uid:-$i}"   
    gid="$uid"
    # generate a random password for each user..    
    pw="${pw:-$(makepasswd --chars=32 | mkpasswd -s -m sha-512)}"
    shell="${shell:-/bin/bash}"
    homedir="${homedir:-/home/$u}"

    useradd  -e "$yesterday" -m -d "$homedir" -c "$gecos" \
             -u "$uid" -g "$gid" -p "$pw" -s "$shell" "$u"

    groupadd -g "$gid" "$u"

done < <(awk -F: '$1 !~ names && $2 !~ uids' names="$names" uids="$uids" "$nf")

# uncomment to warn about users not created:
#echo Users not created because the username or uid already existed: >&2
#awk -F: '$1 ~ names || $2 ~ uids' names="$names" uids="$uids" "$nf" >&2    
