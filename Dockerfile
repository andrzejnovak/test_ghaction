# Base image
FROM alpine:latest

# installes required packages for our script
RUN apk add --no-cache \
  bash \
  ca-certificates \
  curl \
  jq

RUN apk add python3-pip git

RUN pip3 install --upgrade bump2version

# Copies your code file  repository to the filesystem
COPY entrypoint.sh /entrypoint.sh

# change permission to execute the script and
RUN chmod +x /entrypoint.sh

# file to execute when the docker container starts up
ENTRYPOINT ["/entrypoint.sh"]