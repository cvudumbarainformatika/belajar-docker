FROM php:8.3-fpm

# Arguments defined in docker-compose.yml
# ARG user
# ARG uid

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev 

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install mysqli pdo_mysql mbstring exif pcntl bcmath gd && docker-php-ext-enable mysqli

# Get latest Composer & install composer
COPY --from=composer:2.7.7 /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
# RUN groupadd -g 1000 www
# RUN useradd -u 1000 -ms /bin/bash -g www www

COPY . /var/www
COPY --chown=www:www . /var/www

# USER www

EXPOSE 9000

CMD ["php-fpm"]