FROM ubuntu:bionic
LABEL maintainer="Tomoyuki Murakami <tomoyukim@outlook.com>"

COPY assets/* /opt/resource/

RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      ca-certificates \
      curl \
      jq; \
    apt-get clean all; \
    rm -rf /var/lib/apt/lists/*