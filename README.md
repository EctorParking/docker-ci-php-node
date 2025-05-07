# Docker image for Continuous Integration

## Release docker image

Images are hosted in company dockerhub https://hub.docker.com/orgs/ectorparking/repositories

Build and releases are managed by circleci

To trigger a new build and publish in dockerhub you have to create a git tag

create tag, for example version 0.1.0 here
`git tag 0.1.0`

push the tag to origin
`git push origin <TAG_NAME>`

for staging / dev process you can create suffixed tags like `0.1.1-1-staging`


## System information
  * Ubuntu 20.04

## Installed packages
  * sudo
  * autoconf
  * autogen
  * language-pack-en-base
  * wget
  * zip
  * unzip
  * curl
  * rsync
  * ssh
  * openssh-client
  * git
  * build-essential
  * apt-utils
  * software-properties-common
  * nasm
  * libjpeg-dev
  * libpng-dev
  * mySQL Client
  * libpng16-16
  * Dockerize v0.6.1
  * PHP 7.1
    * cli
    * common
    * fpm
    * curl
    * mbstring
    * zip
    * simplexml
    * soap
    * mysql
    * intl
  * Wkhtmltopdf 0.12.5
  * Composer
  * Node.js 12.x
    * npm 6
    * yarn
  * Python3
    * pip
    * awsebcli
    * awscli
