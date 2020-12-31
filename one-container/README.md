# Pi-Hole + Unbound on Docker - 1 Container

## Description

This Docker deployment runs both Pi-Hole and Unbound in a single container. 

The base image for the container is the [official Pi-Hole container](https://hub.docker.com/r/pihole/pihole), with an extra build step added to install the Unbound resolver directly into to the container based on [instructions provided directly by the Pi-Hole team](https://docs.pi-hole.net/guides/unbound/).

## Usage

First create a `.env` file to substitute variables for your deployment. 

Example:

```
ServerIP=192.168.1.10
TZ=America/Los_Angeles
WEBPASSWORD=QWERTY123456asdfASDF
REV_SERVER=true
REV_SERVER_DOMAIN=local
REV_SERVER_TARGET=192.168.1.1
```

#### Available environment variables

> Descriptions borrowed from [official pihole container](https://github.com/pi-hole/docker-pi-hole/):

| Docker Environment Var | Description|
| --- | --- |
| `ServerIP: <Host's IP>`<br/> **Recommended** | **--net=host mode requires** Set to your server's LAN IP, used by web block modes and lighttpd bind address
| `TZ: <Timezone>`<br/> **Recommended** *Default: UTC* | Set your [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) to make sure logs rotate at local midnight instead of at UTC midnight.
| `WEBPASSWORD: <Admin password>`<br/> **Recommended** *Default: random* | http://pi.hole/admin password. Run `docker logs pihole \| grep random` to find your random pass.
| `REV_SERVER: <"true"\|"false">`<br/> *Optional* *Default: "false"* | Enable DNS conditional forwarding for device name resolution
| `REV_SERVER_DOMAIN: <Network Domain>`<br/> *Optional* | If conditional forwarding is enabled, set the domain of the local network router
| `REV_SERVER_TARGET: <Router's IP>`<br/> *Optional* | If conditional forwarding is enabled, set the IP of the local network router


```bash
docker-compose up -d
````