#!/bin/sh
# Dừng script ngay lập tức nếu có lỗi
set -e

# Chạy composer install để đảm bảo các vendor được cài đặt
echo "Running composer install..."
composer install --no-interaction --prefer-dist --optimize-autoloader

# Xóa cache để tránh xung đột
echo "Clearing caches..."
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Xử lý quyền cho thư mục storage và bootstrap/cache
# Kiểm tra sự tồn tại của thư mục trước khi chown/chmod
if [ -d "storage" ]; then
    echo "Fixing permissions for storage..."
    chown -R www-data:www-data storage
    chmod -R 775 storage
fi

if [ -d "bootstrap/cache" ]; then
    echo "Fixing permissions for bootstrap/cache..."
    chown -R www-data:www-data bootstrap/cache
    chmod -R 775 bootstrap/cache
fi

# 🔑 Fix permissions for database.sqlite if it exists
if [ -f "database/database.sqlite" ]; then
    echo "Fixing permissions for database/database.sqlite..."
    chown www-data:www-data database/database.sqlite
    chmod 664 database/database.sqlite
fi

# 🔑 Copy .env if not exists
if [ ! -f ".env" ]; then
    echo "No .env file found, copying from .env.example..."
    cp .env.example .env

    echo "Generating APP_KEY..."
    php artisan key:generate
fi

echo "Entrypoint script finished. Starting PHP-FPM..."

# Dòng này rất quan trọng. Nó sẽ thực thi lệnh được truyền vào từ CMD của Dockerfile (trong trường hợp này là "php-fpm")
# Nếu không có dòng này, container sẽ chạy xong script và tự động tắt.
exec "$@"