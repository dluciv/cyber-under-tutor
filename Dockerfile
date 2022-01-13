FROM alpine:latest

COPY entrypoint.sh c-check.py /

RUN apk add cppcheck grep

# JSON syntax here is required to pass parameters
ENTRYPOINT ["/entrypoint.sh"]
