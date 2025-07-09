FROM ubuntu:20.04

ENV TZ=UTC
RUN export LC_ALL=C.UTF-8
RUN DEBIAN_FRONTEND=noninteractive
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
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
    mysql-client \
    libpng16-16 \
    libxml2-dev \
    vim \
    nano \
    zlib1g-dev \
    xorg \
    libssl-dev \
    libxrender-dev \
    gdebi \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    libfreetype6-dev

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