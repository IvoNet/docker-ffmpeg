FROM ubuntu:18.04
LABEL maintainer="Ivo Woltring - @ivonet"

RUN apt-get update \
 && apt-get install --no-install-recommends -y  \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT [""]
