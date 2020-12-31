FROM pihole/pihole:latest
COPY install_unbound_and_start.sh install_unbound_and_start.sh
RUN apt update && apt install -y unbound

COPY lighttpd-external.conf /etc/lighttpd/external.conf 
COPY unbound-pihole.conf /etc/unbound/unbound.conf.d/pi-hole.conf

CMD install_unbound_and_start.sh