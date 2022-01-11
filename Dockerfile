FROM alpine:latest

COPY entrypoint.sh c-check.py /

RUN apk add git cppcheck grep ruby python3 py3-pip \
 && pip3 install pyyaml anybadge

ENTRYPOINT /entrypoint.sh
