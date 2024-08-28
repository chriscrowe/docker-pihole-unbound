
# Pi-Hole + Unbound - Combined Container

## Overview

This repository provides a Docker-based deployment that integrates Pi-Hole and Unbound into a single, streamlined container. The base image utilizes the [official Pi-Hole container](https://hub.docker.com/r/pihole/pihole), enhanced with additional steps to install and configure the Unbound DNS resolver. The setup includes automated downloading and updating of the root hints file, following [best practices as outlined by the Pi-Hole team](https://docs.pi-hole.net/guides/unbound/).

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Usage Instructions](#usage-instructions)
  - [Environment Configuration](#1-environment-configuration)
  - [Sample `.env` File](#2-sample-env-file)
  - [Using Portainer Stacks](#3-using-portainer-stacks)
  - [Deploying the Stack](#4-deploying-the-stack)
  - [Unbound Root Hints Automation](#5-unbound-root-hints-automation)
- [Troubleshooting](#troubleshooting)
  - [Common Issues](#common-issues)
  - [Viewing Logs](#viewing-logs)
- [Updating the Container](#updating-the-container)
- [Contributing](#contributing)
- [License](#license)
- [Additional Resources](#additional-resources)

## Prerequisites

Before you begin, ensure you have the following installed:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- (Optional) [Portainer](https://www.portainer.io/) if you prefer a UI-based management tool

## Usage Instructions

### 1. Environment Configuration

Begin by creating a `.env` file to define your environment-specific variables. This file will be used to customize your deployment settings.

### Pi-Hole Environment Variables

> The following environment variables are based on the official Pi-Hole Docker container documentation. Adjust these according to your network configuration and preferences:

| Variable              | Default       | Example Value                    | Description                                                                                 |
|-----------------------|---------------|----------------------------------|---------------------------------------------------------------------------------------------|
| `TZ`                  | `UTC`         | `America/New_York`               | Set your [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) to ensure log rotation aligns with local time. |
| `WEBPASSWORD`         | random        | `YourSecurePassword123`          | Password for accessing the Pi-Hole admin interface at `http://pi.hole/admin`. Retrieve it by running `docker logs pihole \| grep random`. |
| `FTLCONF_LOCAL_IPV4`  | unset         | `192.168.1.100`                  | The LAN IP address of your server, used by Pi-Hole’s web block modes and Lighttpd binding.  |
| `REV_SERVER`          | `false`       | `true`                           | Enable DNS conditional forwarding to resolve local device names.                            |
| `REV_SERVER_DOMAIN`   | unset         | `localdomain`                    | Set the domain name of your local network for conditional forwarding.                       |
| `REV_SERVER_TARGET`   | unset         | `192.168.1.1`                    | Specify the IP address of your local network router.                                        |
| `REV_SERVER_CIDR`     | unset         | `192.168.1.0/24`                 | Define the reverse DNS zone for your network (e.g., `192.168.1.0/24`).                      |
| `WEBTHEME`            | `default-light` | `default-dark`                 | Choose the user interface theme (`default-dark`, `default-light`, `lcars`, etc.).           |

### 2. Sample `.env` File

Below is a sample `.env` file that you can adapt to your environment:

```bash
FTLCONF_LOCAL_IPV4=192.168.1.100
TZ=America/New_York
WEBPASSWORD=YourSecurePassword123
REV_SERVER=true
REV_SERVER_DOMAIN=localdomain
REV_SERVER_TARGET=192.168.1.1
REV_SERVER_CIDR=192.168.1.0/24
HOSTNAME=pihole
DOMAIN_NAME=pihole.local
PIHOLE_WEBPORT=80
WEBTHEME=default-dark
```

### 3. Using Portainer Stacks

> **Note:** As of 2022-03-11, the requirement to remove the volumes declaration may no longer apply in Portainer. Please test without modification first.

If you encounter issues with Portainer stacks, consider removing the named volumes declaration from the top of the `docker-compose.yaml` file before pasting it into Portainer's stack editor:

```yaml
volumes:
  etc_pihole-unbound:
  etc_pihole_dnsmasq-unbound:
```

### 4. Deploying the Stack

To deploy the stack using Docker Compose, execute the following command:

```bash
docker-compose up -d
```

> If deploying via Portainer, paste the contents of `docker-compose.yaml` into the stack configuration editor, and set your environment variables directly through the Portainer UI.

### 5. Unbound Root Hints Automation

This deployment includes an automated process for downloading and updating the Unbound root hints file during the Docker image build. The root hints file is crucial for ensuring Unbound queries authoritative root DNS servers directly, improving DNS resolution accuracy and reliability.

#### Implementation Details

- **Script Execution:** The Docker image includes a script (`download-root-hints.sh`) that:
  - [Downloads the latest root hints file from Internic](https://www.internic.net/domain/named.cache).
  - Stores the root hints file at `/var/lib/unbound/root.hints`.
  - Updates Unbound’s configuration to reference the latest root hints file.

- **Dockerfile Configuration:** The Dockerfile has been updated to include and execute this script during the build process, ensuring the container always uses the latest root hints.

By maintaining up-to-date root hints, this deployment ensures that Unbound operates with the most current information available, enhancing the overall security and reliability of your DNS resolution.

## Troubleshooting

### Common Issues

- **Issue:** `FTLCONF_LOCAL_IPV4` not set or incorrect.
  - **Solution:** Ensure that `FTLCONF_LOCAL_IPV4` is correctly set to your server’s LAN IP address. This IP must be accessible by other devices on your network.

- **Issue:** Pi-hole admin interface is not accessible.
  - **Solution:** Verify that the `PIHOLE_WEBPORT` is correctly mapped in your `docker-compose.yaml` file and that no other services are using the same port.

- **Issue:** DNS resolution fails.
  - **Solution:** Check the Unbound logs within the container for any errors related to root hints. Ensure the script has successfully downloaded and configured the root hints file.

### Viewing Logs

You can view the logs for the running Pi-Hole container using:

```bash
docker logs pihole
```

## Updating the Container

To update the container to the latest version of Pi-Hole and Unbound:

1. Pull the latest image:
   ```bash
   docker-compose pull
   ```
2. Recreate and start the container:
   ```bash
   docker-compose up -d --force-recreate
   ```

## Contributing

Contributions are welcome! Please read the [CONTRIBUTING.md](CONTRIBUTING.md) file for details on our code of conduct, and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Additional Resources

- [Pi-Hole Documentation](https://docs.pi-hole.net/)
- [Unbound Documentation](https://nlnetlabs.nl/documentation/unbound/)
- [Docker Documentation](https://docs.docker.com/)
