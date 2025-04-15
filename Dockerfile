FROM ubuntu:20.04

RUN export LC_ALL=C.UTF-8
RUN DEBIAN_FRONTEND=noninteractive
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get install -y \
    sudo \
    autoconf \
    autogen \
    language-pack-en-base \
    wget \
    zip \
    unzip \
    curl \
    rsync \
    ssh \
    openssh-client \
    git \
    build-essential \
    apt-utils \
    software-properties-common \
    nasm \
    libjpeg-dev \
    libpng-dev \
    libpng16-16

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# RUN wget -q -O /tmp/libpng12.deb http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1.1_amd64.deb \
#   && dpkg -i /tmp/libpng12.deb \
#   && rm /tmp/libpng12.deb

# Dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# PHP
RUN apt-get install -y software-properties-common gnupg ca-certificates
RUN mkdir -p /etc/apt/keyrings \
&& curl -fsSL https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /etc/apt/keyrings/sury.gpg \
&& echo "deb [signed-by=/etc/apt/keyrings/sury.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

RUN apt-get update && apt-get install -y php8.1RUN apt-get update
RUN apt-get install -y \
    php8.1-curl \
    php8.1-gd \
    php8.1-dev \
    php8.1-xml \
    php8.1-bcmath \
    php8.1-mysql \
    php8.1-mbstring \
    php8.1-zip \
    php8.1-sqlite \
    php8.1-soap \
    php8.1-intl \
    php8.1-imap \
    php-xdebug \
    php-memcached \
    vim \
    git \
    curl \
    xvfb \
    libfontconfig \
    wkhtmltopdf

COPY wkhtmltopdf /bin
RUN chmod +x /bin/wkhtmltopdf

RUN command -v php

# AWS
RUN apt-get install -y \
    python-pip \
    python-dev
RUN pip install setuptools awsebcli
RUN sudo pip install awscli

# Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer && \
    composer self-update --preview
RUN command -v composer

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs ocaml libelf-dev -y
RUN npm install -g yarn
RUN command -v node
RUN command -v npm

# Other
RUN mkdir ~/.ssh
RUN touch ~/.ssh_config
RUN mkdir ~/phpunit
RUN npm install newman --global
RUN npm install newman-reporter-html --global

# Display versions installed
RUN php -v
RUN composer --version
RUN node -v
RUN npm -v
