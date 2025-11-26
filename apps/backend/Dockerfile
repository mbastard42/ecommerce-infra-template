FROM php:8.3 AS dev

WORKDIR /app

RUN apt-get update \
    && apt-get install -y git unzip libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql \
    && rm -rf /var/lib/apt/lists/*
    
COPY ./composer ./symfony/composer.json ./symfony/composer.lock ./
RUN ./composer install --no-interaction --prefer-dist --no-scripts --no-progress

COPY ./symfony ./

CMD ["php","-S", "0.0.0.0:8000", "-t", "public"]