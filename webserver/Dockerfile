# Project based on https://github.com/spujadas/lighttpd-docker
# Use Alpine Linux base image
FROM alpine:3.8

# Some information
LABEL Maintainer "Andreas Elser"
LABEL Version "0.1"
LABEL Name "Balluff Simple Webserver"

# Update packages, install lighttpd and clean apt
RUN apk --no-cache --no-progress upgrade
RUN apk --no-cache --no-progress add lighttpd

# Copy the lighttpd configuration files
ADD etc/lighttpd/* /etc/lighttpd/

# Open port 3000 on container start because of user context ports > 1024 can be used
EXPOSE 3000

# Copy the HTML project files
ADD www/ /var/www/localhost/htdocs/

# Provide the following volumes for later usage
VOLUME /var/www/localhost/
VOLUME /etc/lighttpd/

# Create a new user and set some permissions
RUN chown -R lighttpd /var/log/lighttpd
RUN touch /var/run/lighttpd.pid
RUN chown lighttpd /var/run/lighttpd.pid

# Use the new created user
USER lighttpd

# Start and run the lighttpd service manually and use the necessary config
ENTRYPOINT [ "/usr/sbin/lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf" ]