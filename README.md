# About

On this project we provide a simple but powerful webserver in a small and fast container image.

Also this project is to test the integration between Github and the [Docker Cloud](https://cloud.docker.com) for automated building and testing after git push.

## References

- Official [Alpine Docker Hub image](https://hub.docker.com/_/alpine/) as base
- Webserver [lighttpd](http://www.lighttpd.net/)
- Configuration files and build instructions for lighttpd in a Docker container from [spujadas/lighttpd-docker](https://github.com/spujadas/lighttpd-docker)
- Tutorial [How To Configure a Continuous Integration Testing Environment with Docker and Docker Compose on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-configure-a-continuous-integration-testing-environment-with-docker-and-docker-compose-on-ubuntu-14-04)
- For automated build tests - [CLI for validating html using validator.w3.org/nu](https://github.com/zrrrzzt/html-validator-cli)

## Project sources

If you want to change the webserver configuration download the files directly from our [Github project site](https://github.com/Balluff/docker-sws) and change it.

## Container usage

Pull this container via `docker pull balluff/simplewebserver` and run it with the following minimal parameter set:

```sh
docker run --name web_test -d --rm -p 3000:3000 balluff/simplewebserver
```

You can then open your webbrowser and access the simple web site via `http://localhost:3000`.

## Container mount binds

After mount bind the directory into the container:

```sh
docker run --name web_test -d --rm -v CONFIGS_FROM_HOST:/etc/lighttpd/ -p 3000:3000 balluff/simplewebserver
```

Other HTML context can also mounted to the container:

```sh
docker run --name web_test -d --rm -v HTML_FROM_HOST:/var/www/localhost/htdocs/ -p 3000:3000 balluff/simplewebserver
```

## Docker compose

### Run service

You can also use Docker Compose to start the web service. For this download the compose file from the Github project site or copy-paste the following content into a new `docker-compose.yml` file.

```yml
version: "3"

networks:
  webnet:
    driver: bridge

services:

  web:
    image: balluff/simplewebserver
    container_name: sws
    restart: always
    ports:
      - "3000:3000"
    networks:
      - webnet
```

Start the service with `docker-compose up -d`.

### Build service

You can also rebuild the container image for your own usage. To do this there are 2 possible options.

- Build the container image with the sources and the `docker build` command. For example `docker build -t myownwebserver .` . Please be patient that you've set the correct build context!

- Edit the `docker-compose.yml` file and set the build instruction instead of the image from Docker Hub:

  ```yml
  ...
  services:

    web:
      build: x86_64
  ...
  ```

  You can then build the image and run the service via `docker-compose build` or to build the service and start it after that via `docker-compose up -d --build`.
  Stopping the service can be done via `docker-compose down`.

## Continous Integration Pipeline with Docker Cloud

To optimize the CI pipeline for the container image builds you can use various build providers. Because Docker provides us the [Docker Cloud](https://cloud.docker.com) we can use it to automatically test and create container images.

Therefore the Docker Cloud agent needs a compose file called `docker-compose.test.yml`. But the automatic test starts only if the option `Internal Pull Requests` in section `AUTOTEST` for the current Docker repository is activated.

![docker_cloud_autotest_feature](https://raw.githubusercontent.com/Balluff/docker-sws/master/screens/docker_cloud_autotest_feature.png)

This chapter tries to give a short but useful overview to create tests for further container usage.

For system tests use the `docker-compose.test.yml` file. This file has build instructions for a Linux container and runs a script on execution.
The scripts validates the given `index.html` and its content.

We use the [HTML validator application](https://github.com/zrrrzzt/html-validator-cli) version based on Node.js to validate the `index.html` file.
If were there errors the validator app returns exit code 1 and the automatic build process will stop on the Docker Cloud platform.
After that we can resolve the mistakes and re-run the service again.

But first we need to build and run the tests like the following scenarios:

```sh
# Build the container
docker-compose -f docker-compose.test.yml build

# Run the service (use "-d" to run it in the background)
docker-compose -f docker-compose.test.yml up

# Build and run the service with one command
docker-compose -f docker-compose.test.yml up --build

# Stopping the service and clean-up the resources
docker-compose -f docker-compose.test.yml down
```

Have a look inside the docker log for the test result:

```sh
docker logs -f docker-testing_sut_1
```

The HTML validator will shown errors if some exists like the screen below:

![local_sut_html_validator_errors](https://raw.githubusercontent.com/Balluff/docker-sws/master/screens/local_sut_html_validator_errors.png)

After fixing the errors we need to re-run the compose test service and only warnings are shown:

![local_sut_html_validator_warnings](https://raw.githubusercontent.com/Balluff/docker-sws/master/screens/local_sut_html_validator_warnings.png)

**Note:** There are many more features we can use to validate our HTML file but for this scenario the default usage is sufficient.

The compose test service file:

```yml
version: "3"

networks:
  webnet:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 171.5.0.0/24

volumes:
  web_data: {}

services:

  sut:
    build: test
    container_name: sws_sut
    depends_on:
      - web
    volumes:
      - web_data:/tmp/
    networks:
      webnet:
        ipv4_address: 171.5.0.20

  web:
    build: x86_64
    container_name: sws
    volumes:
      - web_data:/var/www/localhost/htdocs/:ro
    expose:
      - 3000
    networks:
      webnet:
        ipv4_address: 171.5.0.10
```

## Architecture

The following architecture shows the project file structure, processes and the Github account linking to Docker Hub/Cloud.

![docker testing github docker cloud](https://raw.githubusercontent.com/Balluff/docker-sws/master/architecture/docker_testing_github_docker_cloud.png)