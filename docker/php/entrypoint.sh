#!/bin/bash
set -e

# Vérification de l'existence du projet
if [ ! -f composer.json ]; then
    echo "Création d'un nouveau projet Symfony ${SYMFONY_VERSION}..."
    symfony new . --version="${SYMFONY_VERSION}" --${SYMFONY_TEMPLATE:-webapp} --no-git
    
    # Correction des permissions
    chown -R www-data:www-data .
fi

exec docker-php-entrypoint "$@"
