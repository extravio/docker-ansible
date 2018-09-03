FROM php72-dev

MAINTAINER Mikael Mrozik

CMD ["./vendor/bin/phpunit", "app/tests"]

WORKDIR /var/www/html

COPY scripts/wait-for-it.sh .

RUN chmod +x wait-for-it.sh

COPY ss4 /var/www/html

RUN composer install

COPY ./docker/test/test.env .env

LABEL application=ss4