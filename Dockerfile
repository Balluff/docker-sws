# Project based on https://github.com/spujadas/lighttpd-docker
# Use Ubuntu 18.04 base image
FROM ubuntu:18.04

# Some information
LABEL Maintainer "Andreas Elser"
LABEL Version "0.1"
LABEL Name "Balluff Docker Cloud Testing"

# Update packages, install lighttpd and clean apt
RUN apt update
RUN apt upgrade -y
RUN apt install -y lighttpd \
                curl \
                && apt clean autoclean \
                && apt autoremove --yes \
                && rm -rf /var/lib/apt/*

# Copy the lighttpd configuration files
ADD etc/lighttpd/* /etc/lighttpd/

# Open port 3000 on container start
EXPOSE 3000

# Copy the HTML project files
ADD www/* /var/www/localhost/htdocs/

# Provide the following volumes for later usage
VOLUME /var/www/localhost/
VOLUME /etc/lighttpd/

# Create a new user and set some permissions
RUN adduser --disabled-password --gecos '' lighttpd
RUN chown -R lighttpd /var/log/lighttpd
RUN touch /var/run/lighttpd.pid
RUN chown lighttpd /var/run/lighttpd.pid

# Use the new created user
USER lighttpd

# Start and run the lighttpd service manually and use the necessary config
ENTRYPOINT [ "/usr/sbin/lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf" ]