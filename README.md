# Ansible Runner Docker Image

This project builds a docker image with all of the dependencies required to run `ansible-playbook` and `ansible-lint`.

## Image Details

### Users

- `ansible` - This image contains a user for use by ansible. This user enables SSH from inside of the container.

### Mounts

- `/app` - The expected mount location for an ansible project
- `/home/ansible/.ssh` - The ansible user's SSH Directory. Private keys can be mounted inside of this directory for use by ansible-playbook during runs.
