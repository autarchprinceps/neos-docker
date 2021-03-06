FROM php:apache

RUN chown -R www-data: /var/www

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt update && apt install -y unzip git libmagickwand-dev imagemagick && apt clean all

RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
RUN pecl install imagick && docker-php-ext-enable imagick

COPY apache2.conf /etc/apache2/apache2.conf
COPY vhost.conf /etc/apache2/sites-available/000-default.conf
RUN ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled

USER www-data:www-data

RUN composer create-project neos/neos-base-distribution .

USER root:root
# CMD ./flow server:run