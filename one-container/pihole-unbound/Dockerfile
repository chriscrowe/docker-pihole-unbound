FROM pihole/pihole:latest
COPY install_unbound_and_start.sh install_unbound_and_start.sh
RUN apt update && apt install -y unbound

CMD start.sh