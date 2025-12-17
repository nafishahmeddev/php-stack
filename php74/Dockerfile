FROM php:7.4-fpm

COPY install.sh /usr/local/bin/install.sh
RUN chmod +x /usr/local/bin/install.sh && /usr/local/bin/install.sh

COPY config.ini /usr/local/etc/php/php.ini
COPY php-fpm.conf /usr/local/etc/php-fpm.d/zz-socket.conf

RUN mkdir -p /var/run/php \
    && chown www-data:www-data /var/run/php \
    && rm -f /usr/local/etc/php-fpm.d/zz-docker.conf

WORKDIR /var/www/html
