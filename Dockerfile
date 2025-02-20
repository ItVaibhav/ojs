# Use an official PHP image with Apache
FROM php:8.1-apache

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    libxml2-dev \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd intl xml

# Enable Apache mod_rewrite (important for OJS)
RUN a2enmod rewrite

# Install Composer (for PHP dependency management)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the document root to /var/www/html (default location for Apache)
WORKDIR /var/www/html

# Download and unzip the OJS source code
COPY . /var/www/html

# Set correct permissions for OJS files
RUN chown -R www-data:www-data /var/www/html

# Expose the web server port
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
