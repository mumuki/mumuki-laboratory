#!/bin/bash

if [ "$1" == "init" ]; then
    docker/init.sh
fi

MUMUKI_DEV_IP=localhost
MUMUKI_PLATFORM_DOMAIN=$MUMUKI_DEV_IP:3000 \
MUMUKI_ORGANIZATION_MAPPING=path \
MUMUKI_COOKIES_DOMAIN=$MUMUKI_DEV_IP \
SECRET_KEY_BASE=aReallyStrongKeyForDevelopment \
  bundle exec rails s -p 3000 -b 0.0.0.0
