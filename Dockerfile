FROM alpine
MAINTAINER Negash <i@negash.ru>

RUN apk add --update wget

ENV DOCKERIZE_VERSION v0.2.0

ENV VOLUME /config

RUN wget --no-check-certificate https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm -rf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY ./docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]