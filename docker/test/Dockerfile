FROM php72-dev

MAINTAINER Mikael Mrozik

CMD ["./vendor/bin/phpunit", "app/tests"]

# COPY ss4 /var/www/html

WORKDIR /var/www/html

COPY scripts/wait-for-it.sh .

RUN chmod +x wait-for-it.sh

RUN git clone https://github.com/extravio/docker-ansible.git project

WORKDIR /var/www/html/project/ss4

RUN composer install

COPY ./docker/test/test.env .env

