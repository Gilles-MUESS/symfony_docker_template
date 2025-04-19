FROM php:8.4-fpm

ARG APP_UID=1000
ARG APP_GID=1000
ARG APP_USER=appuser
ARG APP_GROUP=appgroup
ARG SYMFONY_VERSION=7.2.x

ENV HOME=/home/${APP_USER} \
	SYMFONY_CLI_HOME=/home/${APP_USER}/.symfony5

# Dépendances système
RUN apt-get update && apt-get install -y \
	acl file gettext git unzip libzip-dev libicu-dev libpng-dev libjpeg-dev \
	libfreetype6-dev libonig-dev rsync curl \
	&& rm -rf /var/lib/apt/lists/*

RUN set -eux; \
	docker-php-ext-install \
	pdo_mysql \
	zip \
	intl \
	gd \
	opcache \
	;

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --2 \
	&& mv composer.phar /usr/local/bin/composer

# Installer la Symfony CLI (en tant que root)
COPY --from=ghcr.io/symfony-cli/symfony-cli:latest /usr/local/bin/symfony /usr/local/bin/symfony

# Configuration PHP
COPY app.ini /usr/local/etc/php/conf.d/app.ini

# Créer utilisateur/groupe applicatif
RUN groupadd -g ${APP_GID} ${APP_GROUP} \
	&& useradd -m -u ${APP_UID} -g ${APP_GROUP} -s /bin/bash ${APP_USER}

# Préparer le HOME et droits
RUN mkdir -p /var/www && chown -R ${APP_USER}:${APP_GROUP} /var/www \
	&& mkdir -p /home/${APP_USER}/.symfony5 && chown -R ${APP_USER}:${APP_GROUP} /home/${APP_USER}

WORKDIR /var/www

# Entrypoint
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm"]
