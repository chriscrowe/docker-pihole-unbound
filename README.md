# Pi-Hole + Unbound on Docker (works on Synology)

## Description

Running Pi-Hole in Docker can be challenging due to networking requirements by Pi-Hole, this is especially true when the ports that Pi-Hole uses are shared by the host it's running on (this is true for Synology in the default configuration).

This project uses a [`macvlan` Docker network](https://docs.docker.com/network/macvlan/) to place your containers on your main network, with their own IP addresses and MAC addresses. Pi-Hole uses Unbound as it's resolver, and Unbound uses Cloudflare (1.1.1.1) upstream in order to support DNSSEC and DNS-over-TLS.

- Uses 2 Containers
  - Pi-Hole ([pihole/pihole](https://hub.docker.com/r/pihole/pihole)) - Official from Pi-Hole
  - Unbound ([mvance/unbound](https://hub.docker.com/r/mvance/unbound))


## Instructions

### Before running...

- Update some things in the docker compose, such as your IP addresses/subnets. 
- Add a `.env` file next to the docker-compose.yaml so you can pass in the `${WEBPASSWORD}`
- Update the secondary/backup nameserver in the `resolv.conf` file
- Lastly you might want to provide some manual DNS entries in the `dnsmasq.conf` and/or `hosts` files

### Run it!

```bash
sudo docker-compose up -d
```

### Test it!

Test your configuration with dig:

```bash
dig google.com @192.168.1.248
# Expecting "status: NOERROR"
```

You can also test for DNSSEC functionality:

```bash
dig sigfail.verteiltesysteme.net @192.168.1.248
# Expecting "status: SERVFAIL"

dig sigok.verteiltesysteme.net @192.168.1.248
# Expecting "status: NOERROR"
```

### Serve it! 

If all looks good, configure your router/DHCP server to serve your new Pi-Hole IP address (`192.168.1.248`) to your clients. 


##  Acknowledgements

- [http://tonylawrence.com/posts/unix/synology/free-your-synology-ports/][synology-ports]
- [https://github.com/MatthewVance/unbound-docker][unbound-docker]
- [https://pi-hole.net][pihole]
- [https://nlnetlabs.nl/projects/unbound/about/][unbound]

[synology-ports]: http://tonylawrence.com/posts/unix/synology/free-your-synology-ports/
[unbound-docker]: https://github.com/MatthewVance/unbound-docker
[pihole]: https://pi-hole.net
[unbound]: https://nlnetlabs.nl/projects/unbound/about/