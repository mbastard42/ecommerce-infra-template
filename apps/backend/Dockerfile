FROM php:8.3-fpm AS base
WORKDIR /app
RUN apt-get update \
    && apt-get install -y git unzip libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql \
    && rm -rf /var/lib/apt/lists/*
COPY ./symfony/composer ./symfony/composer.json ./symfony/composer.lock ./

FROM base AS dev
RUN ./composer install \
    --no-interaction \
    --no-scripts
COPY ./symfony ./

FROM base AS build
ENV APP_ENV=prod \
    APP_DEBUG=0
RUN ./composer install \
    --prefer-dist \
    --no-scripts \
    --no-progress \
    --no-dev \
    --optimize-autoloader
COPY ./symfony ./
RUN php bin/console cache:clear --env=prod \
    && php bin/console cache:warmup --env=prod

FROM dunglas/frankenphp:1-php8.3 AS prod
ENV APP_ENV=prod \
    APP_DEBUG=0 \
    SERVER_NAME=":8080"
WORKDIR /app
COPY --from=build /app ./
EXPOSE 8080

# DISTROLESS ONE DAY

# FROM dunglas/frankenphp:static-builder-musl-1 AS frankenphp
# WORKDIR /go/src/app/dist/app
# COPY --from=build /app ./
# WORKDIR /go/src/app
# ENV EMBED=dist/app/
# RUN ./build-static.sh

# FROM gcr.io/distroless/static AS prod
# COPY --from=frankenphp /go/src/app/dist/frankenphp-linux-aarch64 /usr/local/bin/app
# EXPOSE 80
# ENTRYPOINT ["/usr/local/bin/app"]
# CMD ["php-server"]