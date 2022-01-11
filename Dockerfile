FROM alpine:latest

COPY entrypoint.sh c-check.py /

RUN apk add cppcheck grep python3 py3-pip \
 && pip3 install pyyaml anybadge

# JSON syntax here is required to pass parameters
ENTRYPOINT ["/entrypoint.sh"]
