FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Base Setup & PPA
RUN apt-get update && apt-get install -y \
    software-properties-common curl zip unzip git \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update

# 2. Install PHP 7.3 & Extensions for Testing
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
    php7.3-gmp \
    php7.3-intl \
    php7.3-soap \
    && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. Install wkhtmltopdf dependencies
RUN apt-get update && apt-get install -y \
    libxrender1 \
    libfontconfig1 \
    libxext6 \
    libx11-6 \
    libjpeg-turbo8 \
    libpng16-16 \
    xfonts-75dpi \
    xfonts-base \
    fontconfig \
    wget \
    ca-certificates \
    && wget -q http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.23_amd64.deb \
    && dpkg -i libssl1.1_1.1.1f-1ubuntu2.23_amd64.deb || true \
    && rm -f libssl1.1_1.1.1f-1ubuntu2.23_amd64.deb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 4. Configure PHP-FPM
RUN mkdir -p /run/php

# Disable opcache for testing
RUN phpdismod -v 7.3 -s ALL opcache || true

# Copy configs
COPY test-php.ini /etc/php/7.3/cli/php.ini
COPY test-php-fpm.conf /etc/php/7.3/fpm/pool.d/z-test.conf

# Create test directory and initialize composer
RUN mkdir -p /test && cd /test && composer init --name="test/spreadsheet" --no-interaction \
    && composer config audit.block-insecure false

WORKDIR /test

EXPOSE 9000

CMD ["php-fpm7.3", "-F"]
