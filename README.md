# Ansible Runner Docker Image

This project builds a docker image with all of the dependencies required to run `ansible-playbook` and `ansible-lint`.

## Image Details

### Environment Variables

| Environment Variable | Description                            |
| -------------------- | -------------------------------------- |
| `PUID`               | User ID of the primary ansible user    |
| `PGID`               | Group ID for the priamry ansible group |

### Users

| User      | Description                                                                                                                                            |
| --------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `ansible` | This is the default user, for use by ansible. This user enables SSH from inside of a container, when used with a SSH bind mount (see "Mounts", below). |

### Mounts

| Mount                | Description                                                                                                                             |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `/app`               | The expected mount path for an ansible project                                                                                          |
| `/home/ansible/.ssh` | The default ansible user's SSH Directory. Private keys can be mounted inside of this directory for use by ansible-playbook during runs. |

## Usage

This image can be used by any ansible project. If SSH is required, be sure to mount the `~/.ssh` so the local user's keys are available.

```shell
docker run \
    --rm -it \
    --pull always \
    --network host \
    -e PUID=${id -u} \
    -e PGID=${id -g} \
    --mount type=bind,source=".",target=/app \
    --mount type=bind,source="${HOME}/.ssh",target=/home/ansible/.ssh,readonly \
    ghcr.io/gamersoutreach/ansible-runner:latest \
    ansible-playbook -e "ansible_ssh_user=${USER}" -i inventory.yml site.yml
```
