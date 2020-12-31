# Pi-Hole + Unbound on Docker

### Use Docker to run [Pi-Hole](https://pi-hole.net) with an upstream [Unbound](https://nlnetlabs.nl/projects/unbound/about/) resolver.

Changing this repo to support 2 different docker-compose configurations now:

- [`one-container`](one-container/) (new) - Install Unbound directly into the Pi-Hole container
  - This configuration contacts the DNS root servers directly, please read the Pi-Hole docs on [Pi-hole as All-Around DNS Solution](https://docs.pi-hole.net/guides/unbound/) to understand what this means.
  - With this approach, we can also simply our networking since `macvlan` is no longer necessary.
- [`two-container`](two-container/) (legacy) - Use separate containers for Pi-Hole and Unbound
  - This configuration uses MatthewVance's [unbound-docker](https://github.com/MatthewVance/unbound-docker) container to implement encrypted DNS to third party DNS resolvers (eg Cloudflare). This is arguably less privacy-friendly since you're handing your DNS queries to those 3rd party providers.
