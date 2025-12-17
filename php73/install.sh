#!/bin/bash
set -e

apt-get update && apt-get install -y \
    libzip-dev libpng-dev libjpeg-dev libfreetype6-dev \
    libonig-dev libxml2-dev libxslt1-dev zip unzip curl git \
    libssl-dev

# 1. Install & Enable Shared Extensions
# These will create .ini files in conf.d by default.
# We will disable them by removing those .ini files, 
# so the user can control them purely from the mounted php.ini.

# Configure GD
docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr

# Install Extensions
docker-php-ext-install -j$(nproc) \
    calendar exif gettext mysqli pdo_mysql pcntl shmop sockets \
    sysvmsg sysvsem sysvshm wddx xsl zip gd opcache

# 2. Cleanup default configuration files
# This ensures that extensions are NOT enabled twice (once by default, once by your config).
# You will strictly enable them in your single php.ini file with 'extension=xxx'
rm -f /usr/local/etc/php/conf.d/docker-php-ext-*.ini

apt-get clean && rm -rf /var/lib/apt/lists/*
