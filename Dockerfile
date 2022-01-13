FROM alpine:latest

COPY entrypoint.sh c-check.py /

RUN apk add cppcheck grep \
 && apk add python3

# JSON syntax here is required to pass parameters
ENTRYPOINT ["/entrypoint.sh"]
