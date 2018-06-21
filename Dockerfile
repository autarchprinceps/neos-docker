FROM php:apache

RUN chown -R www-data: /var/www

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt update && apt install -y unzip git libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng-dev && apt clean all

RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

COPY apache2.conf /etc/apache2/apache2.conf
COPY vhost.conf /etc/apache2/sites-available/000-default.conf
RUN ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled

USER www-data:www-data

RUN composer create-project neos/neos-base-distribution .

USER root:root
# CMD ./flow server:run