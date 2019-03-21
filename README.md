# docker-w3af

Docker image for the Open Source Web Application Security Scanner [w3af](http://w3af.org/)

> w3af is a Web Application Attack and Audit Framework. The project’s goal is to create a framework to help you secure your web applications by finding and exploiting all web application vulnerabilities.

The [dockerfile](https://github.com/andresriancho/w3af/blob/master/extras/docker/Dockerfile) provided in the w3af Github repo started with `FROM ubuntu:12.04`, so I didn't read much further and built it myself using Alpine Linux

## Build image

build-args: 

- ALPINE_VERSION: specifies Alpine Linux version to use (default: v3.9)
- W3AF_BRANCH: github branch to use (default: master)

```bash
$ git clone https://github.com/joxz/docker-w3af

$ cd docker-w3af

$ docker build -t docker-w3af .

# check docker images

$ docker images
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
docker-w3af                     latest              7c73c8b6ab0c        42 minutes ago      277MB
...
```

## Pull from Docker Hub

```bash
docker pull jones2748/docker-w3af
```

## Usage

### Run container

```bash
docker run -it --rm -v ${PWD}:/app docker-w3af /opt/w3af/w3af_console -y -n -s /app/test.w3af
```

### Root access

```bash
docker run -it --rm -v ${PWD}:/app docker-w3af makemeroot
```