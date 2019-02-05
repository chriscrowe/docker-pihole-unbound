# Pi-Hole + Unbound on Docker

#### (Synology-compatible!)

## Description

Running Pi-Hole in Docker can be challenging due to networking requirements by Pi-Hole, this is especially true when the ports that Pi-Hole uses are shared by the host it's running on (this is true for Synology in the default configuration).

This project uses a [`macvlan` Docker network](https://docs.docker.com/network/macvlan/) to place your containers on your main network, with their own IP addresses and MAC addresses. Pi-Hole uses Unbound as it's resolver, and Unbound uses Cloudflare (1.1.1.1) upstream in order to support DNSSEC and DNS-over-TLS.

- This docker-compose runs the following 2 containers
  - Pi-Hole ([pihole/pihole](https://hub.docker.com/r/pihole/pihole)) - Official from Pi-Hole
  - Unbound ([mvance/unbound](https://hub.docker.com/r/mvance/unbound)) - There are several choices here but I like this one the best


## Instructions

### Hold your horses and configure some stuff first...

- Update docker-compose to match your environment, eg. IP addresses/subnets. 
	- Take note of the `networks.home.driver_opts.parent` value, the default value of `ovs_eth1` is for using the 2nd ethernet port on a Synology NAS with `Open vSwitch` enabled, if disabled use `eth1` instead, or whichever other interface you might be using in your setup.
- Add a `.env` file next to the docker-compose.yaml so you can pass in the `${WEBPASSWORD}` - this is your Pi-Hole admin password. You can optionally leave this step out and set the password via CLI (`pihole -a -p`) after the Pi-Hole is running
- Update the secondary/backup nameserver in the `resolv.conf` file, or remove it if you don't have a backup (would recommend having one!)
- Lastly, optionally, you can provide some manual DNS entries in the `dnsmasq.conf` and/or `hosts` files

### Run it!

```bash
sudo docker-compose up -d
```

__Note__: If you're using Synology, you'll need to `scp` these files to your NAS and run it from the CLI since `docker-compose` is not currently supported through their DSM GUI.

### Test it!

Test your configuration with dig

> __Note__: change the IP to your new Pi-Hole's IP

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

> Note: it may take some time for the current DHCP leases to renew and for clients to get the new DNS service info -- generally the default is 24 hours or less.


##  Acknowledgements

- [http://tonylawrence.com/posts/unix/synology/free-your-synology-ports/][synology-ports]
- [https://github.com/MatthewVance/unbound-docker][unbound-docker]
- [https://pi-hole.net][pihole]
- [https://nlnetlabs.nl/projects/unbound/about/][unbound]

[synology-ports]: http://tonylawrence.com/posts/unix/synology/free-your-synology-ports/
[unbound-docker]: https://github.com/MatthewVance/unbound-docker
[pihole]: https://pi-hole.net
[unbound]: https://nlnetlabs.nl/projects/unbound/about/