#!/bin/bash
set -e

apt-get update && apt-get install -y \
    libzip-dev libpng-dev libjpeg-dev libfreetype6-dev \
    libonig-dev libxml2-dev libxslt1-dev zip unzip curl git \
    libssl-dev

# Configure GD (Modern)
docker-php-ext-configure gd --with-freetype --with-jpeg

# Install Extensions
docker-php-ext-install -j$(nproc) \
    calendar exif gettext mysqli pdo_mysql pcntl shmop sockets \
    sysvmsg sysvsem sysvshm xsl zip gd opcache

# Cleanup default configuration files

apt-get clean && rm -rf /var/lib/apt/lists/*
