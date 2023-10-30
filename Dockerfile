FROM php:fpm-alpine3.18

COPY configs/php-fpm.conf /usr/local/etc/php-fpm.conf
COPY configs/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY configs/www.conf /usr/local/etc/www.conf
COPY configs/php.ini /usr/local/etc/php/php.ini

RUN apk --update add \
    zlib-dev \
    libpng-dev \
    icu-dev \
    libzip-dev \
    libmcrypt-dev \
    libtool \
    tidyhtml-dev

RUN  apk --no-cache add --virtual .build-deps $PHPIZE_DEPS \
    && apk --no-cache add --virtual .ext-deps libmcrypt-dev freetype-dev

RUN docker-php-ext-install gd intl opcache pdo_mysql posix session tidy zip mysqli
RUN docker-php-ext-enable gd intl opcache pdo_mysql posix session tidy zip mysqli

RUN pecl mcrypt_compat

EXPOSE 9000
CMD ["php-fpm", "-F"]