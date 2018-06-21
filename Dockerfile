FROM php:apache

RUN chown -R www-data: /var/www

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt update && apt install unzip && apt clean all

RUN docker-php-ext-install mysqli

USER www-data:www-data

RUN composer create-project --no-dev neos/neos-base-distribution .