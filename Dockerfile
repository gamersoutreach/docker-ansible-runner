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
WORKDIR /app

# Create user for ssh
RUN <<EOF
    set -eux
    useradd -m ansible
    mkdir -p /home/ansible/.ssh
    chown -R ansible:ansible /home/ansible/.ssh
EOF

# Install runtime dependencies
RUN <<EOF
    set -eux
    apt-get update
    apt-get install -y --no-install-recommends libssh-dev
    rm -rf /var/lib/apt/lists/*
EOF

# Install python dependencies
COPY overlay/ /
RUN <<EOF
    set -eux
    pip install -r /opt/buildpack/requirements.txt
EOF

# Install ansible dependencies
USER ansible
RUN <<EOF
    set -eux
    ansible-galaxy collection install -r /opt/buildpack/requirements.yaml
EOF
