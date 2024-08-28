# Pi-Hole + Unbound - 1 Container

## Description

This Docker deployment runs both Pi-Hole and Unbound in a single container.

The base image for the container is the [official Pi-Hole container](https://hub.docker.com/r/pihole/pihole), with additional build steps added to install the Unbound DNS resolver directly into the container and automate the downloading of the root hints file, based on [instructions provided directly by the Pi-Hole team](https://docs.pi-hole.net/guides/unbound/).

## Usage

First, create a `.env` file to substitute variables for your deployment.

### Pi-hole Environment Variables

> Vars and descriptions replicated from the [official Pi-hole container documentation](https://github.com/pi-hole/docker-pi-hole/#environment-variables):

| Variable | Default | Value | Description |
| -------- | ------- | ----- | ----------- |
| `TZ` | UTC | `<Timezone>` | Set your [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) to make sure logs rotate at local midnight instead of at UTC midnight. |
| `WEBPASSWORD` | random | `<Admin password>` | [http://pi.hole/admin](http://pi.hole/admin) password. Run `docker logs pihole \| grep random` to find your random pass. |
| `FTLCONF_LOCAL_IPV4` | unset | `<Host's IP>` | Set to your server's LAN IP, used by web block modes and lighttpd bind address. |
| `REV_SERVER` | `false` | `<"true"\|"false">` | Enable DNS conditional forwarding for device name resolution. |
| `REV_SERVER_DOMAIN` | unset | Network Domain | If conditional forwarding is enabled, set the domain of the local network router. |
| `REV_SERVER_TARGET` | unset | Router's IP | If conditional forwarding is enabled, set the IP of the local network router. |
| `REV_SERVER_CIDR` | unset | Reverse DNS | If conditional forwarding is enabled, set the reverse DNS zone (e.g., `192.168.0.0/24`). |
| `WEBTHEME` | `default-light` | `<"default-dark"\|"default-darker"\|"default-light"\|"default-auto"\|"lcars">` | User interface theme to use. |

### Example `.env` File

Create a `.env` file in the same directory as your `docker-compose.yaml` file, for example:

```env
FTLCONF_LOCAL_IPV4=192.168.1.10
TZ=America/Los_Angeles
WEBPASSWORD=QWERTY123456asdfASDF
REV_SERVER=true
REV_SERVER_DOMAIN=local
REV_SERVER_TARGET=192.168.1.1
REV_SERVER_CIDR=192.168.0.0/16
HOSTNAME=pihole
DOMAIN_NAME=pihole.local
PIHOLE_WEBPORT=80
WEBTHEME=default-light
```

### Using Portainer Stacks?

> **Note:** As of 2022-03-11, the following advice may no longer be necessary in Portainer. If you're using Portainer, first try it without removing the volumes declaration and see if it works.

Portainer stacks may require you to remove the named volumes declaration from the top of the `docker-compose.yaml` file before pasting it into Portainer's stack editor:

```yaml
volumes:
  etc_pihole-unbound:
  etc_pihole_dnsmasq-unbound:
```

### Running the Stack

To deploy the stack using Docker Compose, run:

```bash
docker-compose up -d
```

> If using Portainer, paste the `docker-compose.yaml` contents into the stack config and add your environment variables directly in the Portainer UI.

### Unbound Root Hints Automation

This container setup includes a process that automatically downloads and updates the Unbound root hints file during the Docker image build. The root hints file provides a list of authoritative root DNS servers that Unbound uses to resolve DNS queries directly.

#### How It Works:

- **Script:** A script (`download-root-hints.sh`) is included in the Docker image that:
  - [Downloads the latest root hints file from Internic](https://www.internic.net/domain/named.cache).
  - Saves the root hints file to `/var/lib/unbound/root.hints`.
  - Updates the Unbound configuration to use the downloaded root hints.

- **Dockerfile:** The Dockerfile has been updated to include this script and ensure it is executed during the build process, ensuring the root hints are always up-to-date.

This setup enhances the accuracy and reliability of DNS resolution by ensuring that Unbound always starts with the latest information on root DNS servers.
