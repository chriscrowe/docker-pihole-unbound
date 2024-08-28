# Use an ARG to allow overriding the Pi-hole version during the build
ARG PIHOLE_VERSION=latest

# Base image from Pi-hole, defaulting to the latest version
FROM pihole/pihole:${PIHOLE_VERSION}

# Install Unbound and other necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends unbound curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up the Unbound service directory and copy the run script    
RUN mkdir -p /etc/services.d/unbound
COPY unbound-run /etc/services.d/unbound/run

# Ensure the run script is executable
RUN chmod +x /etc/services.d/unbound/run

# Copy configuration files for Lighttpd, Unbound, and DNSmasq
COPY lighttpd-external.conf /etc/lighttpd/external.conf 
COPY unbound-pihole.conf /etc/unbound/unbound.conf.d/pi-hole.conf
COPY 99-edns.conf /etc/dnsmasq.d/99-edns.conf

# Add a script to download the root hints file
COPY download-root-hints.sh /usr/local/bin/download-root-hints.sh

# Ensure the script is executable
RUN chmod +x /usr/local/bin/download-root-hints.sh

# Run the root hints download script and set up Unbound service directory
RUN /usr/local/bin/download-root-hints.sh

# Set the entrypoint to initialize the s6 supervisor
ENTRYPOINT ["./s6-init"]

# Optional: Add a healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD pgrep unbound || exit 1