# Container image that runs your code
FROM alpine:latest

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
COPY c-check.py /c-check.py

RUN apk add cppcheck bc grep ruby python3 py3-pip \
 && pip3 install pyyaml anybadge

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
