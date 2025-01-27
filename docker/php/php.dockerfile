############################################
# Base Image
############################################
FROM serversideup/php:8.3-fpm-nginx-bookworm AS base

############################################
# Development Image
############################################
FROM base AS development

# Switch to root so we can do root things
USER root

# Adding packages for Code coverage
RUN install-php-extensions pcov 

# Install pcntl
RUN docker-php-ext-install pcntl

# Install PHP extensions
RUN pecl install redis swoole
RUN docker-php-ext-install pdo_mysql exif pcntl bcmath gd intl soap
RUN docker-php-ext-enable redis swoole
RUN docker-php-ext-configure intl

# Save the build arguments as a variable
ARG USER_ID
ARG GROUP_ID

# Use the build arguments to change the UID
# and GID of www-data while also changing
# the file permissions for NGINX
RUN docker-php-serversideup-set-id www-data $USER_ID:$GROUP_ID && \
    \
    # Update the file permissions for our NGINX service to match the new UID/GID
    docker-php-serversideup-set-file-permissions --owner $USER_ID:$GROUP_ID --service nginx


# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*



# Drop back to our unprivileged user
USER www-data

# RUN php artisan optimize:clear
# RUN php artisan optimize

# ENTRYPOINT ["php", "artisan", "octane:start", "--server=swoole", "--port=8500", "--host=0.0.0.0"]


############################################
# Production Image
############################################

# Since we're calling "base", production isn't
# calling any of that permission stuff
FROM base AS production

# Copy our app files as www-data (33:33)
COPY --chown=www-data:www-data . /var/www/html