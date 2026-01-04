FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# 1. Base Setup & PPA
RUN apt-get update && apt-get install -y \
    software-properties-common curl zip unzip git \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update

# 2. Install PHP & Common Extensions
RUN apt-get install -y \
    php8.0-fpm \
    php8.0-cli \
    php8.0-common \
    php8.0-bcmath \
    php8.0-curl \
    php8.0-gd \
    php8.0-mbstring \
    php8.0-mysql \
    php8.0-opcache \
    php8.0-readline \
    php8.0-xml \
    php8.0-xsl \
    php8.0-zip \
    php8.0-gmp \
    php8.0-intl \
    php8.0-soap \
    php8.0-sqlite3 \
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
    && wget -q http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.23_amd64.deb \
    && dpkg -i libssl1.1_1.1.1f-1ubuntu2.23_amd64.deb || true \
    && rm -f libssl1.1_1.1.1f-1ubuntu2.23_amd64.deb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. Configure PHP-FPM
# Create the PID directory
RUN mkdir -p /run/php

# Disable opcache by moving it out
RUN phpdismod -v 8.0 -s ALL opcache || true

# 4. Custom Scripts & Configs
COPY install.sh /usr/local/bin/install.sh
RUN chmod +x /usr/local/bin/install.sh && /usr/local/bin/install.sh

WORKDIR /var/www

EXPOSE 9000

CMD ["php-fpm8.0", "-F"]
