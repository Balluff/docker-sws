# Use the Alpine base image
FROM alpine:3.8

# Some information
LABEL Maintainer "Andreas Elser"
LABEL Version "0.1"
LABEL Name "Balluff Simple Webserver Healthchecker"

# Install curl
RUN apk add --no-cache curl

# Change the work directory
WORKDIR /app

# Copy the testing script and make it executable
ADD ci_build_test.sh /app/ci_build_test.sh
RUN chmod +x ci_build_test.sh

# Run the test script
CMD [ "/app/ci_build_test.sh" ]