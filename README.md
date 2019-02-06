# Pi-Hole + Unbound on Docker

#### (Synology-compatible!)

## Description

Running Pi-Hole in Docker can be challenging due to networking requirements by Pi-Hole, this is especially true when the ports that Pi-Hole uses are shared by the host it's running on (this is true for Synology in the default configuration).

This project uses a [`macvlan` Docker network](https://docs.docker.com/network/macvlan/) to place your containers on your main network, with their own IP addresses and MAC addresses. 

- This docker-compose runs the following 2 containers
  - Pi-Hole ([pihole/pihole](https://hub.docker.com/r/pihole/pihole)) - Official from Pi-Hole
  - Unbound ([mvance/unbound](https://hub.docker.com/r/mvance/unbound)) - There are several choices here but I like this one the best

Pi-Hole uses Unbound as it's resolver, and Unbound uses Cloudflare (1.1.1.1) and CleanBrowsing upstream in order to support DNSSEC and DNS-over-TLS. **This is an important detail** about this particular setup-- we are not making queries direct to the root servers as some of the Pi-Hole docs show in their examples. Here's a snippet from the [Unbound config](https://github.com/MatthewVance/unbound-docker/blob/master/1.8.3/unbound.sh) (v1.8.3 as of writing this doc) showing what's happening:

```
...
    forward-zone:
        # Forward all queries (except those in cache and local zone) to
        # upstream recursive servers
        name: "."
        
        # Queries to this forward zone use TLS
        forward-tls-upstream: yes
        
        # https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Test+Servers


        # Cloudflare
        forward-addr: 1.1.1.1@853#cloudflare-dns.com
        forward-addr: 1.0.0.1@853#cloudflare-dns.com

        # CleanBrowsing
        forward-addr: 185.228.168.9@853#security-filter-dns.cleanbrowsing.org
        forward-addr: 185.228.169.9@853#security-filter-dns.cleanbrowsing.org
...
```

If you want to change any of this Unbound config then you can fork MatthewVance's [unbound-docker repo](https://github.com/MatthewVance/unbound-docker) and modify his `unbound.sh` file.

## Disclaimer

Using this type of configuration on a Synology NAS is somewhat of an advanced use-case, and it should come with some security/stability considerations:

- Enabling SSH on your Synology NAS is non-default and should be done with care. 
	- I would recommend __(1)__ configuring SSH to not use default port 22 and __(2)__ to __never__ forward the SSH port outside of your home network.
- Poking around in the Synology CLI can lead to bad things in your NAS if you you don't know what you're doing. As a rule of thumb I would not touch any files outside of the `/volumeX/` folders unless you know what you're doing. These are the folders which are reflected to the user inside of `File Station` GUI.


## Instructions

### Hold your horses and configure some stuff first...

- Update `docker-compose.yaml` to match your environment, eg. IP addresses/subnets. 
	- Take note of the `networks.home.driver_opts.parent` value, the default value of `ovs_eth1` is for using the 2nd ethernet port on a Synology NAS with `Open vSwitch` enabled (configured in `Control Panel` -> `Network` -> `Network Interface` -> `Manage`), if disabled use `eth1` instead, or whichever other interface you might be using in your setup.
- Add a `.env` file next to the docker-compose.yaml so you can pass in the `${WEBPASSWORD}` - this is your Pi-Hole admin password. You can optionally leave this step out and set the password via CLI (`pihole -a -p`) after the Pi-Hole is running
- Update the secondary/backup nameserver in the `pihole/config/resolv.conf` file, or remove it if you don't have a backup (would recommend having one!)
- Lastly, optionally, you can provide some manual DNS entries in the `pihole/config/dnsmasq.conf` and/or `pihole/config/hosts` files

### Run it!

Copy the files up to your Docker host (eg Synology)

> __Note__: Synology does not support `docker-compose` via their GUI but the running containers that get created here will be visible there when you're done.

On client machine:

```bash
# Make sure the target directory exists first! 
#  Can use something like `mkdir -p /volume1/docker/pihole-unbound`

cd docker-pihole-unbound
scp -r ./* myuser@synology.local:/volume1/docker/pihole-unbound/
```

On the Docker host (eg Synology)

```bash
cd /volume1/docker/pihole-unbound
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

### Update it!

When updated container images are released you can execute these commands on your Docker host to pull them in and run them

```bash
cd /volume1/docker/pihole-unbound
sudo docker-compose down
sudo docker-compose pull
sudo docker-compose up -d
```

##  Acknowledgements

- [http://tonylawrence.com/posts/unix/synology/free-your-synology-ports/][synology-ports]
- [https://github.com/MatthewVance/unbound-docker][unbound-docker]
- [https://pi-hole.net][pihole]
- [https://nlnetlabs.nl/projects/unbound/about/][unbound]

[synology-ports]: http://tonylawrence.com/posts/unix/synology/free-your-synology-ports/
[unbound-docker]: https://github.com/MatthewVance/unbound-docker
[pihole]: https://pi-hole.net
[unbound]: https://nlnetlabs.nl/projects/unbound/about/