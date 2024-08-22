# Use an ARG to allow overriding the Pi-hole version during the build
ARG PIHOLE_VERSION=latest

# Base image from Pi-hole, defaulting to the latest version
FROM pihole/pihole:${PIHOLE_VERSION}

# Install Unbound
RUN apt-get update && apt-get install -y unbound && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy configuration files for Lighttpd, Unbound, and DNSmasq
COPY lighttpd-external.conf /etc/lighttpd/external.conf 
COPY unbound-pihole.conf /etc/unbound/unbound.conf.d/pi-hole.conf
COPY 99-edns.conf /etc/dnsmasq.d/99-edns.conf

# Set up the Unbound service directory and copy the run script
RUN mkdir -p /etc/services.d/unbound
COPY unbound-run /etc/services.d/unbound/run

# Ensure the run script is executable
RUN chmod +x /etc/services.d/unbound/run

# Set the entrypoint to initialize the s6 supervisor
ENTRYPOINT ["./s6-init"]