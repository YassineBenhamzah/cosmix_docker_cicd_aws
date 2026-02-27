FROM php:8.1-fpm-alpine

# Install necessary system dependencies and PHP extensions
RUN apk add --no-cache libpng-dev libzip-dev zip unzip \
    && docker-php-ext-install pdo pdo_mysql gd zip

# Install Composer securely
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copy all your Laravel backend files and CSS directly
COPY . .

# Install PHP dependencies (production mode)
RUN composer install --no-dev --optimize-autoloader

# Optimize Laravel for maximum speed
RUN php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# Set proper folder permissions for the server
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 9000 for PHP-FPM
EXPOSE 9000
CMD ["php-fpm"]