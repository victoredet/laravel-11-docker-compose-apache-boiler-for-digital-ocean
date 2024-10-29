# Use PHP 8.2 as the base image (adjust the version as needed)
FROM php:8.2-apache

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Install necessary packages and extensions
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libpng-dev \
    libwebp-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libzip-dev \
    zip \
    git \
    # mysql-client \
    && docker-php-ext-install \
    pdo_mysql \
    gd \
    zip \
    && a2enmod rewrite


# Download and install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install Composer dependencies
# RUN composer install --prefer-dist --no-dev --no-scripts
RUN composer install

# Set environment variables
ENV COMPOSER_HOME /app
ENV COMPOSER_CACHE_DIR /app/cache

# Set the user and group
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 80 for the web server
EXPOSE 80

# Start Apache in the foreground
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
