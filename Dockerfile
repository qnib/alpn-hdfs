FROM qnib/alpn-jdk8

RUN apk upgrade --update && \
    rm -rf /tmp/* /var/cache/apk/*
