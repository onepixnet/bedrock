ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm-alpine

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN set -eux && \
    apk update && \
    apk add git subversion bash mariadb-client && \
    apk del && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /root/history && \
    chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions @composer xdebug exif gd mysqli zip opcache && \
    ln -s composer /usr/local/bin/c && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY --link php.ini $PHP_INI_DIR/conf.d/
COPY --link fpm.conf /usr/local/etc/php-fpm.d/zzz-docker.conf
RUN set -eux && \
    cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" && \
    mkdir /var/run/php

VOLUME /var/www/html
WORKDIR /var/www/html

CMD ["/bin/bash", "-c", "bash docker/php/install.sh && php-fpm"]