# Use the Alpine base image
FROM node:11.11.0-alpine

# Some information
LABEL Maintainer "Andreas Elser"
LABEL Version "1.0"
LABEL Vendor "Balluff"
LABEL Name "Balluff Simple Webserver container tests"
LABEL Architecture "x86_64"

# Upgrade the system
RUN apk update && apk upgrade \
    && rm -rf /var/cache/apk/* /tmp/*

# Install the HTML validator
RUN npm i html-validator-cli -g

# Copy the testing script and make it executable
ADD entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Run the test script
ENTRYPOINT [ "entrypoint.sh" ]