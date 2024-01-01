ARG PIHOLE_VERSION
FROM pihole/pihole:${PIHOLE_VERSION:-latest}
RUN apt update && apt install -y unbound

COPY /config/lighttpd-external.conf /etc/lighttpd/external.conf 
COPY /config/02-custom-settings.conf /etc/dnsmasq.d/02-custom-settings.conf
COPY /config/unbound-pihole.conf /etc/unbound/unbound.conf.d/pi-hole.conf
COPY /config/99-edns.conf /etc/dnsmasq.d/99-edns.conf
COPY /config/resolv.conf /etc/resolv.conf
RUN mkdir -p /etc/services.d/unbound
COPY unbound-run /etc/services.d/unbound/run

ENTRYPOINT ./s6-init

