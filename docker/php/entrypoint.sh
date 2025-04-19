#!/bin/bash
set -e

APP_USER=${APP_USER:-appuser}
APP_GROUP=${APP_GROUP:-appgroup}
APP_UID=${APP_UID:-1000}
APP_GID=${APP_GID:-1000}
export HOME=/home/$APP_USER
export SYMFONY_CLI_HOME=$HOME/.symfony5

# S'assurer que les droits sont bons sur /var/www

cd /var/www

# Création du projet Symfony si nécessaire
if [ ! -f composer.json ]; then
	echo "Création du projet Symfony dans /tmp/project..."
	symfony new /tmp/project --version="${SYMFONY_VERSION}" --webapp --no-git

	# Si un .env a été généré, le renommer en .env.local AVANT la copie
	if [ -f /tmp/project/.env ]; then
		mv /tmp/project/.env /tmp/project/.env.local
	fi

	echo "Copie du projet Symfony (en excluant compose.yaml et .env)..."
	rsync -a --exclude=compose.yaml /tmp/project/ .

	rm -rf /tmp/project

	composer install --prefer-dist --no-progress --no-interaction
fi

exec docker-php-entrypoint "$@"
