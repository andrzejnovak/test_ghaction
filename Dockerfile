# Base image
FROM alpine:latest

# installes required packages for our script
RUN apk add --no-cache \
  bash \
  ca-certificates \
  curl \
  jq


RUN apk add --update-cache \
    python3 \
    python3-dev \
    py3-pip \
    build-base \
    git \
  && rm -rf /var/cache/apk/*

RUN pip install --upgrade bump2version

# Copies your code file  repository to the filesystem
COPY entrypoint.sh /entrypoint.sh

# change permission to execute the script and
RUN chmod +x /entrypoint.sh

# file to execute when the docker container starts up
ENTRYPOINT ["/entrypoint.sh"]