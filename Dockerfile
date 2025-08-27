FROM wordpress:6.8-php8.4-apache

WORKDIR /var/www/html

# Delete everything except readme.html
RUN find . -mindepth 1 ! -iname "readme.html" -exec rm -rf {} + && \
    echo "Remaining files:" && ls -al

EXPOSE 80
