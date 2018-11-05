#!/bin/sh

# Wait some seconds
sleep 5

# Use curl to connect to the local webserver inside the container's network.
# Search for the content inside the index.html.
if curl -f http://web:3000; then
    echo "Tests passed!"
    exit 0
else
    echo "Tests failed!"
    exit 1
fi