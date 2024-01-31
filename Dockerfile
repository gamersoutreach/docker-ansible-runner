FROM python:3.12-bookworm
LABEL description="Ansible Run Container"
ENV PYTHONUNBUFFERED=1 \
    LANG="C.UTF-8" \
    LANGUAGE="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    LC_CTYPE="C.UTF-8"

# Create app directory
RUN set -eux; \
    mkdir /app

# Create ansible user with explicit uid
RUN <<EOF
    set -eux
    groupadd -r ansible --gid=1000
    useradd -m -u 1000 -g 1000 ansible
    mkdir -p /home/ansible/.ssh
    chown -R ansible:ansible /home/ansible
EOF

# Install system runtime dependencies
RUN <<EOF
    set -eux
    apt-get update
    apt-get install -y --no-install-recommends libssh-dev gosu
    rm -rf /var/lib/apt/lists/*
EOF

# Install python runtime dependencies
COPY overlay/ /
RUN <<EOF
    set -eux
    pip install -r /opt/buildpack/requirements.txt
    su -c "ansible-galaxy collection install -r /opt/buildpack/requirements.yaml" ansible
EOF

VOLUME /app
VOLUME /home/ansible/.ssh
WORKDIR /app
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]