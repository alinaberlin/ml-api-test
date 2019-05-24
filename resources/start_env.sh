#!/bin/bash

docker build -t database_test_ml .

docker run -it -d --restart unless-stopped -p 127.0.0.1:6666:5432 --name database-ml database_test_ml -c max_connections=1000

git clone git@bitbucket.org:medici-living/ml-api.git

cd ml-api

git checkout SD-1207

composer install

docker build -t symfony4test docker/.

docker run -d --name symfony4test -p 0.0.0.0:6001:443 \
--link database-ml:db \
-v /tmp:/storage \
-e CONTAINER_APP_ENV=prod \
-e CONTAINER_DISABLE_DELIVERY=true \
-e CONTAINER_DATABASE_DRIVER=pdo_pgsql \
-e CONTAINER_DATABASE_HOST=db \
-e CONTAINER_DATABASE_PORT=5432 \
-e CONTAINER_DATABASE_NAME=mldata \
-e CONTAINER_DATABASE_USER=mladmin \
-e CONTAINER_DATABASE_PASSWORD=mladmin \
-e CONTAINER_DATABASE_VERSION=9.6.2 \
-e CONTAINER_MAILER_TRANSPORT=smtp \
-e CONTAINER_MAIL_ADDRESS_NOTIFY=dominik.winter@medici-living.de \
-e CONTAINER_MLWEB_URL="http://local.www.medici-living.de" \
-e CONTAINER_STORAGE_BASEPATH="/storage" \
-e CONTAINER_STORAGE_BASEURL="http://localhost/storage" \
-e CONTAINER_VERSION_TAG="X.X.X" \
-e CONTAINER_GIT_TAG="xxxxx" \
-e CONTAINER_ENVIRONMENT_TAG=prod \
-e CONTAINER_MAILER_TRANSPORT=smtp \
-e CONTAINER_MAILER_HOST="aspmx.l.google.com" \
-e CONTAINER_MAILER_USER="null" \
-e CONTAINER_MAILER_PASSWORD="null" \
-e CONTAINER_MAILER_PORT=25 \
-e CONTAINER_MAILER_ENCRYPTION="null" \
-e CONTAINER_MAILER_AUTH_MODE="null" \
-e CONTAINER_MAILER_DEBUG_MODE=true \
-e CONTAINER_DELIVERY_ADDRESS="dominik.winter@medici-living.de" \
-e CONTAINER_DISABLE_DELIVERY=false \
-e CONTAINER_MAIL_ADDRESS_SUPPORT="dominik.winter@medici-living.de" \
-e CONTAINER_MAIL_ADDRESS_LEAD="dominik.winter@medici-living.de" \
-e CONTAINER_MAIL_ADDRESS_TERMINATION="dominik.winter@medici-living.de" \
-e CONTAINER_MAIL_ADDRESS_REVOCATION="dominik.winter@medici-living.de" \
-e CONTAINER_SECRET=M6KEF26zh4vNSb8mxvox8niLE84onBqN \
-e CONTAINER_GOOGLE_API_KEY=AIzaSyBTkn26ssbGZ7rcbjxpP3ommmd_7LjUk1 \
-e LOCALE="de" \
-e LOCALES="de" \
symfony4test
