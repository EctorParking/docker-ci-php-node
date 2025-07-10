FROM ubuntu:20.04

ENV TZ=UTC
RUN export LC_ALL=C.UTF-8
RUN DEBIAN_FRONTEND=noninteractive
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y sudo
RUN apt-get install -y autoconf
RUN apt-get install -y autogen
RUN apt-get install -y language-pack-en-base
RUN apt-get install -y wget
RUN apt-get install -y zip
RUN apt-get install -y unzip
RUN apt-get install -y curl
RUN apt-get install -y rsync
RUN apt-get install -y ssh
RUN apt-get install -y openssh-client
RUN apt-get install -y git
RUN apt-get install -y build-essential
RUN apt-get install -y apt-utils
RUN apt-get install -y software-properties-common

RUN apt-get install -y nasm
RUN apt-get install -y libjpeg-dev
RUN apt-get install -y libpng-dev
RUN apt-get install -y libpng16-16
RUN apt-get install -y libfreetype6-dev
RUN apt-get install -y libxrender-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y libzip-dev

RUN apt-get install -y libxml2-dev
RUN apt-get install -y libicu-dev
RUN apt-get install -y libonig-dev

RUN apt-get install -y mysql-client
RUN apt-get install -y vim
RUN apt-get install -y nano
# RUN apt-get install -y xorg
RUN apt-get install -y gdebi

# Add user
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# PHP
RUN apt-get purge -y 'php*' && apt-get autoremove -y
RUN add-apt-repository ppa:ondrej/php && apt-get update && \
    apt-get install -y \
    php8.1 \
    php8.1-cli \
    php8.1-common \
    php8.1-fpm \
    php8.1-curl \
    php8.1-mbstring \
    php8.1-zip \
    php8.1-xml \
    php8.1-soap \
    php8.1-mysql \
    php8.1-intl \
    php8.1-gd \
    php8.1-bcmath
# Install wkhtmltopdf
RUN apt-get update && apt-get install -y wkhtmltopdf

# Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer && \
    composer self-update

# Node.js (use maintained version)
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

# AWS CLI
RUN apt-get install -y python3-pip python3-dev && \
    ln -s /usr/bin/pip3 /usr/bin/pip && \
    pip install setuptools awsebcli awscli

# Final setup
RUN mkdir ~/.ssh && touch ~/.ssh_config

# Display versions installed
RUN php -v && composer --version && node -v && npm -v