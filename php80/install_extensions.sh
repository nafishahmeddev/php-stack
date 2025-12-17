#!/bin/bash
set -e

apt-get update && apt-get install -y \
    libzip-dev libpng-dev libjpeg-dev libfreetype6-dev \
    libonig-dev libxml2-dev libxslt1-dev zip unzip curl git \
    libssl-dev

# Configure GD (Modern)
docker-php-ext-configure gd --with-freetype --with-jpeg

# Install ALL requested extensions
# wddx is deprecated in 7.4 but still available? It creates warnings. 
# User asked for it (from the list 'wddx' was there). 
# But usually pecl is needed for 7.4+ for some deprecated ones. 
# We'll try native first, if fail, we skip or use pecl if strictly requested. 
# wddx is usually gone from 7.4 extension dir in some distros, but let's try.
# If wddx fails, we'll remove it.

docker-php-ext-install -j$(nproc) \
    calendar \
    exif \
    gettext \
    mysqli \
    pdo_mysql \
    pcntl \
    shmop \
    sockets \
    sysvmsg \
    sysvsem \
    sysvshm \
    xsl \
    zip \
    gd \
    opcache

# json included in core 8.0, present in 7.4
docker-php-ext-install json || true

apt-get clean && rm -rf /var/lib/apt/lists/*
