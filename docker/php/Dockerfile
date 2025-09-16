# THAY ĐỔI: Sử dụng base image php:8.3-fpm (Debian)
FROM php:8.3-fpm

# Nhận đối số từ docker-compose.yml
ARG APP_DIR

# THAY ĐỔI: Dùng apt-get (Debian) và tên các package tương ứng
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    libonig-dev \
    libxml2-dev \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Cài đặt các PHP extensions (lệnh này không thay đổi)
# Lưu ý: mbstring đã có sẵn trong image này, nhưng chạy lại cũng không sao
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip
RUN pecl install redis && docker-php-ext-enable redis

# Cài đặt Composer (không thay đổi)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Đặt thư mục làm việc (không thay đổi)
WORKDIR /var/www/${APP_DIR}

# Sao chép entrypoint script vào image
COPY docker/php/entrypoint.sh /usr/local/bin/entrypoint.sh

# Cấp quyền thực thi cho entrypoint script
RUN chmod +x /usr/local/bin/entrypoint.sh

# Thiết lập entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Expose port và CMD (không thay đổi)
EXPOSE 9000
CMD ["php-fpm"]