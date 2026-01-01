FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Base Setup & PPA
RUN apt-get update && apt-get install -y \
    software-properties-common curl zip unzip git \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update

# 2. Install PHP & Common Extensions
RUN apt-get install -y \
    php8.2-fpm \
    php8.2-cli \
    php8.2-common \
    php8.2-bcmath \
    php8.2-curl \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-mysql \
    php8.2-opcache \
    php8.2-readline \
    php8.2-xml \
    php8.2-xsl \
    php8.2-zip \
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

CMD ["php-fpm8.2", "-F"]
