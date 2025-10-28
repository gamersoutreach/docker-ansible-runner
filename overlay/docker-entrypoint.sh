#!/usr/bin/env sh
set -e

PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

# Set UID/GID of ansible user
sed -i "s/^ansible\:x\:1000\:1000/ansible\:x\:$PUID\:$PGID/" /etc/passwd
sed -i "s/^ansible\:x\:1000/ansible\:x\:$PGID/" /etc/group

# Set permissions on home folder
chown $PUID:$PGID /home/ansible

# Step-down from root
exec gosu ansible "${@}"
