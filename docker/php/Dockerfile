FROM php:8.3-fpm

ARG USER_ID=1000
ARG GROUP_ID=1000

ARG SYMFONY_VERSION=7.2.x
ENV SYMFONY_ENV=dev

RUN apt-get update && apt-get install -y \
	git \
	unzip \
	libzip-dev \
	libicu-dev \
	libpng-dev \
	libjpeg-dev \
	libfreetype6-dev \
	libonig-dev \
	&& docker-php-ext-install \
	pdo_mysql \
	zip \
	intl \
	gd \
	opcache

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configurer le user non-root
RUN usermod -u ${USER_ID} www-data && groupmod -g ${GROUP_ID} www-data

WORKDIR /var/www

# Optimisations PHP pour la production
COPY app.ini /usr/local/etc/php/conf.d/app.ini

# Installation de Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash && \
	mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# Script d'initialisation
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER www-data

EXPOSE 9000

# RUN echo "listen = 0.0.0.0:9000" >> /usr/local/etc/php-fpm.d/zz-docker.conf