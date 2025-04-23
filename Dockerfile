FROM ubuntu:20.04

ENV TZ=UTC

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
    mysql-client \
    libpng16-16

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
&& tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
&& rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# PHP
RUN apt-get purge -y 'php*' && apt-get autoremove -y
RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php && apt-get update && apt-get install -y php7.4 php7.4-cli php7.4-common php7.4-fpm php7.4-curl php7.4-mbstring php7.4-zip php7.4-simplexml php7.4-soap php7.4-mysql
RUN command -v php

# Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer && \
    composer self-update
RUN command -v composer

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs -y
RUN npm install npm@6 -g
RUN command -v node
RUN command -v npm

# AWS
RUN apt-get install -y \
    python3-pip \
    python3-dev
RUN [ -e /usr/bin/pip ] || ln -s /usr/bin/pip3 /usr/bin/pip
RUN pip install setuptools awsebcli awscli

# Other
RUN mkdir ~/.ssh
RUN touch ~/.ssh_config

# Display versions installed
RUN php -v
RUN composer --version
RUN node -v
RUN npm -v
