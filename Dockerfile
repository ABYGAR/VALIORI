FROM php:8.2-cli

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    git unzip curl libicu-dev libzip-dev pkg-config libonig-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl mbstring zip

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Carpeta de trabajo
WORKDIR /app

# Copiar todo el proyecto
COPY . .

# Instalar dependencias PHP
RUN composer install --no-dev --optimize-autoloader

# Permisos necesarios para CodeIgniter
RUN chmod -R 777 writable

# Exponer puerto (Railway usa variable PORT)
EXPOSE 8080

# Ejecutar servidor correctamente
CMD php -S 0.0.0.0:$PORT -t public