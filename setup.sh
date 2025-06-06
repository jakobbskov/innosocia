#!/bin/bash
# setup.sh - Provision a Raspberry Pi with Nextcloud
#
# This script installs Apache, PHP, and MariaDB, then downloads and configures
# Nextcloud. It enables all services so that they start automatically at boot.
# Execute as root or using sudo.

set -e

# Update package list and upgrade existing packages
apt-get update
apt-get upgrade -y

# Install required packages for Nextcloud
apt-get install -y \
    apache2 mariadb-server unzip wget \
    php php-gd php-json php-mysql php-curl \
    php-mbstring php-intl php-xml php-zip php-bcmath php-gmp

# Ensure services start on boot
systemctl enable apache2
systemctl enable mariadb

# Configure database for Nextcloud (default password: changeme)
mysql -uroot <<MYSQL
CREATE DATABASE IF NOT EXISTS nextcloud;
CREATE USER IF NOT EXISTS 'nextcloud'@'localhost' IDENTIFIED BY 'changeme';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';
FLUSH PRIVILEGES;
MYSQL

# Download latest Nextcloud and place under /var/www
cd /var/www || exit 1
wget https://download.nextcloud.com/server/releases/latest.zip
unzip latest.zip
chown -R www-data:www-data nextcloud
rm latest.zip

# Configure Apache
cat >/etc/apache2/sites-available/nextcloud.conf <<'APACHECONF'
Alias /nextcloud "/var/www/nextcloud/"

<Directory /var/www/nextcloud/>
  Require all granted
  AllowOverride All
  Options FollowSymLinks MultiViews
</Directory>
APACHECONF

# Enable Nextcloud site and Apache modules
a2ensite nextcloud.conf
a2enmod rewrite headers env dir mime

# Restart Apache to apply changes
systemctl restart apache2

echo "Nextcloud installation complete. Visit http://<your-pi-ip>/nextcloud to finish setup via the web interface."
