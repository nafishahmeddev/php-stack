FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Base Setup & PPA
RUN apt-get update && apt-get install -y \
    software-properties-common curl zip unzip git \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update

# 2. Install PHP & Common Extensions
RUN apt-get install -y \
    php8.1-fpm \
    php8.1-cli \
    php8.1-common \
    php8.1-bcmath \
    php8.1-curl \
    php8.1-gd \
    php8.1-mbstring \
    php8.1-mysql \
    php8.1-opcache \
    php8.1-readline \
    php8.1-xml \
    php8.1-xsl \
    php8.1-zip \
    && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. Configure PHP-FPM
# Create the PID directory
RUN mkdir -p /run/php

# 4. Custom Scripts & Configs
COPY install.sh /usr/local/bin/install.sh
RUN chmod +x /usr/local/bin/install.sh && /usr/local/bin/install.sh

WORKDIR /var/www/html

EXPOSE 9000

CMD ["php-fpm8.1", "-F"]
