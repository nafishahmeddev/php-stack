FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Base Setup & PPA
RUN apt-get update && apt-get install -y \
    software-properties-common curl zip unzip git \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update

# 2. Install PHP & Common Extensions
RUN apt-get install -y \
    php7.4-fpm \
    php7.4-cli \
    php7.4-common \
    php7.4-bcmath \
    php7.4-curl \
    php7.4-gd \
    php7.4-json \
    php7.4-mbstring \
    php7.4-mysql \
    php7.4-opcache \
    php7.4-readline \
    php7.4-xml \
    php7.4-xsl \
    php7.4-zip \
    php7.4-gmp \
    php7.4-intl \
    php7.4-soap \
    && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2.5. Install wkhtmltopdf dependencies
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
    && wget http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb \
    && dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb || true \
    && rm -f libssl1.1_1.1.1f-1ubuntu2_amd64.deb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. Configure PHP-FPM
# Create the PID directory
RUN mkdir -p /run/php

# Disable opcache by moving it out
RUN phpdismod -v 7.4 -s ALL opcache || true

# 4. Custom Scripts & Configs
COPY install.sh /usr/local/bin/install.sh
RUN chmod +x /usr/local/bin/install.sh && /usr/local/bin/install.sh

WORKDIR /var/www

EXPOSE 9000

CMD ["php-fpm7.4", "-F"]
