#!/bin/sh

# Use curl to connect to the local webserver inside the container's network.
# Search for the content inside the index.html.
if curl http://web:3000/index.html | grep "<h3>Simple Webserver</h3>"; then
    echo "Tests with curl and grep passed!"
    exit 0
else
    echo "Tests with curl and grep failed!"
    exit 1
fi