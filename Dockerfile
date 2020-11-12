# Downloading the dependencies
FROM alpine:3.12 AS base
RUN apk update -q && \
    apk add --no-cache openssl-dev imagemagick && \
    apk add --no-cache --virtual .build-deps build-base git

# Building elog
FROM base AS elog-build
WORKDIR /build
RUN git clone https://bitbucket.org/ritt/elog --recursive && \
    cd elog && \
    make && \
    make install && \
    apk del .build-deps && \
    rm -r /build/elog/
    
FROM elog-build AS elog-configure
WORKDIR /usr/local/elog
RUN adduser -S -g elog elog && \
    addgroup -S elog

EXPOSE 8080
CMD ["elogd", "-p", "8080"]