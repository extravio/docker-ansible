FROM php72-dev

MAINTAINER Mikael Mrozik

WORKDIR /var/www/html

COPY ss4 /var/www/html

RUN composer install --no-dev

COPY ./docker/prod/prod.env .env

LABEL application=ss4