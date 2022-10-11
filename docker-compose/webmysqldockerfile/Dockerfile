FROM php:8.0-apache
RUN apt-get update && apt-get upgrade && apt-get install mariadb-client -y 
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN mkdir /var/www/html/images && chmod 777 /var/www/html/images
COPY web/ /var/www/html/