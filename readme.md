# About
This project is about to test the integration between Github and the [docker cloud](https://cloud.docker.com) for automated building and testing after git push.

## References
- Official [Ubuntu Docker Hub image](https://hub.docker.com/_/ubuntu/) as base
- Webserver [lighttpd](http://www.lighttpd.net/)
- Configuration files and build instructions for lighttpd in a Docker container from [spujadas/lighttpd-docker](https://github.com/spujadas/lighttpd-docker)
- Tutorial [How To Configure a Continuous Integration Testing Environment with Docker and Docker Compose on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-configure-a-continuous-integration-testing-environment-with-docker-and-docker-compose-on-ubuntu-14-04)

## Usage
Pull this container via `docker pull balluff/docker-testing` and run it with the following minimal parameter set:
```sh
$ docker run --name web_test -d --rm -p 8080:3000 balluff/docker-testing
```
You can then open your webbrowser and access the simple web site via `http://localhost:8080`.

If you want to change the webserver configuration download the files directly from the [Github project site](https://github.com/bfandreaselser/docker-testing/tree/master/etc/lighttpd) and change it. After mount bind the directory into the container:
```sh
$ docker run --name web_test -d --rm -v CONFIGS_FROM_HOST:/etc/lighttpd/ -p 8080:3000 balluff/docker-testing
```

Other HTML context can also mounted inside the container:
```sh
$ docker run --name web_test -d --rm -v HTML_FROM_HOST:/var/www/localhost/htdocs/ -p 8080:3000 balluff/docker-testing
```

You can also use Docker Compose to start the web service. For this download the compose file from the Github project site or copy-paste the following content into a new `docker-compose.yml`.
```docker
web:
  build: .
  dockerfile: Dockerfile
  ports:
    - "8080:3000"
```

Build the service with `docker-compose -f docker-compose.yml build` and after start it with `docker-compose -f docker-compose.yml up -d`

## Continous Integration Tests
For testing use the `docker-compose.test.yml` file. This file references to `Dockerfile.test` which builds a new Alpine based Linux container and runs a script on execution.
The scripts validates via `curl` if the given index.html content is available. If not the test fails.
Use Docker Compose to build and run the tests:
```sh
docker-compose -f docker-compose.test.yml build
docker-compose -f docker-compose.test.yml up -d
```

Have a look inside the docker log for the test result:
```sh
docker logs -f docker-testing_sut_1
```

## Architecture
The following picture shows the project file structure, architecture and the Github account linking to Docker Hub/Cloud.
![docker testing github docker cloud](https://github.com/bfandreaselser/docker-testing/blob/master/architecture/docker_testing_github_docker_cloud.png)