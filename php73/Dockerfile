FROM php:7.3-fpm

# 1. Installer Script
COPY install.sh /usr/local/bin/install.sh
RUN chmod +x /usr/local/bin/install.sh && /usr/local/bin/install.sh

# 2. PHP Configuration (One File)
# We copy it initially to have a default, but it will be mounted over by docker-compose.
COPY config.ini /usr/local/etc/php/php.ini

# 3. FPM Socket Configuration
COPY php-fpm.conf /usr/local/etc/php-fpm.d/zz-socket.conf

RUN mkdir -p /var/run/php \
    && chown www-data:www-data /var/run/php \
    && rm -f /usr/local/etc/php-fpm.d/zz-docker.conf

WORKDIR /var/www/html
