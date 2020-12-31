# Pi-Hole + Unbound on Docker

Changing this repo to support 2 different docker-compose configurations now:

- [`one-container`](one-container/) (new) - Install Unbound directly into the Pi-Hole container
- [`two-container`](two-container/) (legacy) - Use separate containers for Pi-Hole and Unbound

I have decided to add the single-container approach since the [Pi-Hole docs](https://docs.pi-hole.net/guides/unbound/) now give official instructions on how to do this, so it seems they endorse it. With this approach things are a bit simpler since we don't need to deal with `macvlan` networking.
