FROM pihole/pihole:v5.8.1
RUN apt update && apt install -y unbound

COPY lighttpd-external.conf /etc/lighttpd/external.conf 
RUN echo "include: \"/opt/unbound/*.conf\"" >> /etc/unbound/unbound.conf 
COPY start_unbound_and_s6_init.sh start_unbound_and_s6_init.sh

RUN chmod +x start_unbound_and_s6_init.sh
ENTRYPOINT ./start_unbound_and_s6_init.sh
