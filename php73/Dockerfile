FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Base Setup & PPA
RUN apt-get update && apt-get install -y \
    software-properties-common curl zip unzip git \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update

# 2. Install PHP & Common Extensions
RUN apt-get install -y \
    php7.3-fpm \
    php7.3-cli \
    php7.3-common \
    php7.3-bcmath \
    php7.3-curl \
    php7.3-gd \
    php7.3-json \
    php7.3-mbstring \
    php7.3-mysql \
    php7.3-opcache \
    php7.3-readline \
    php7.3-xml \
    php7.3-xsl \
    php7.3-zip \
    && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. Configure PHP-FPM
# Create the PID directory
RUN mkdir -p /run/php

# Disable opcache by moving it out
RUN phpdismod -v 7.3 -s ALL opcache || true

# 4. Custom Scripts & Configs
COPY install.sh /usr/local/bin/install.sh
RUN chmod +x /usr/local/bin/install.sh && /usr/local/bin/install.sh

WORKDIR /var/www/html

EXPOSE 9000

CMD ["php-fpm7.3", "-F"]
