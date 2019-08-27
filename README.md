# baseimage_statup

## SSH

Enable ssh with `SSH_ENABLE=true`

## Users

Users can be passed to the container via the environment variable `SSH_USERS`, 
or the files `/secrets/users` (preferred) or `/secrets/ssh-users` (backwards compatibility).

File syntax:
```
<1: username>:<2: uid (=gid)>:<3: passwd hash from mkpasswd -m sha-512>:<4: homedir>:<5: full name>:<6: shell>:<7: additional,groups,comma,separated>
```
Everything but the username is optional; the password is randomly generated if necessary:

### Example

```
me.myself:::/home/someone:Myers::root,wheel
```

This generates 

* the user `me.myself` 
* with an automatically chosen uid (in the in the 2000001... range)
* in her own group `me.myself`
* a random password
* the homedir `/home/someone`
* the full name "Myers"
* bash as the shell
* in the additional groups `root` and `wheel`

