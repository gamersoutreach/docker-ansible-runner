#!/usr/bin/env sh
set -e

PUID="${PUID:-1000}"
PGID="${PGID:-1000}"
DOCKERGID="${DOCKERGID:-999}"

# Set UID/GID of ansible user
sed -i "s/^ansible\:x\:1000\:1000/ansible\:x\:$PUID\:$PGID/" /etc/passwd
sed -i "s/^ansible\:x\:1000/ansible\:x\:$PGID/" /etc/group

# Set the GID of the docker group
sed -i "s/^docker\:x\:999/docker\:x\:$DOCKERGID/" /etc/group

# Set permissions on home folder, excluding .ssh mount
chown $PUID:$PGID /home/ansible
find /home/ansible -mindepth 1 -maxdepth 1 -not -name ".ssh" -exec chown -R $PUID:$PGID {} \;

# Step-down from root
exec gosu ansible "${@}"
