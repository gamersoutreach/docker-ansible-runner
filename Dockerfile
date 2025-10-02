FROM python:3.13-trixie

LABEL org.opencontainers.image.title="Ansible Runner"
LABEL org.opencontainers.image.description="Ansible Run Container"
LABEL org.opencontainers.image.vendor="Gamers Outreach Foundation"
LABEL org.opencontainers.image.source="https://github.com/gamersoutreach/docker-ansible-runner"
LABEL org.opencontainers.image.licenses="MIT"

ENV PYTHONUNBUFFERED=1 \
    LANG="C.UTF-8" \
    LANGUAGE="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    LC_CTYPE="C.UTF-8" \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Create directories and ansible user
RUN <<EOF
    set -eux
    mkdir /app
    groupadd -r ansible --gid=1000
    useradd -m -u 1000 -g 1000 ansible
    mkdir -p /home/ansible/.ssh
    chown -R ansible:ansible /home/ansible
EOF

# Install system runtime dependencies
RUN <<EOF
    set -eux
    apt-get update
    apt-get install -y --no-install-recommends \
        gosu \
        libssh-dev \
        sshpass
    rm -rf /var/lib/apt/lists/*
    apt-get clean
EOF

# Install python runtime dependencies
COPY overlay/ /
RUN <<EOF
    set -eux
    pip install --no-cache-dir -r /opt/buildpack/requirements.txt
    ansible-galaxy collection install -r /opt/buildpack/requirements.yaml -p /usr/share/ansible/collections
EOF

VOLUME /app
VOLUME /home/ansible/.ssh
WORKDIR /app

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]