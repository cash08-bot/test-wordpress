FROM wordpress:6.8-php8.4-apache

#Set Working directory
WORKDIR /var/www/html

Run find . -mindepth 1 ! -iname "readme.html" -exec rm -rf {} +

Run chown -R www-data /var/www/html

CMD["apache2-foreground"]
EXPOSE 80
