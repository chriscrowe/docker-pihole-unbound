FROM pihole/pihole:latest
RUN apt update && apt install -y unbound

COPY lighttpd-external.conf /etc/lighttpd/external.conf 
COPY unbound-pihole.conf /etc/unbound/unbound.conf.d/pi-hole.conf
COPY install_unbound_and_start.sh install_unbound_and_start.sh
RUN chmod +x install_unbound_and_start.sh
RUN chmod +x /etc/init.d/unbound
RUN update-rc.d unbound defaults

# CMD ./install_unbound_and_start.sh