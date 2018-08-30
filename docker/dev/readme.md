# Set up

docker pull php:7.2-apache

docker build -t php72-dev .

docker run -d -p 80:80 --name php72 -v "$PWD":/var/www/html php72-dev

docker exec -it php72 bash

composer create-project silverstripe/installer ./my/website/folder ^4