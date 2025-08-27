FROM wordpress:6.8-php8.4-apache

# Set working directory
WORKDIR /var/www/html

# Preserve readme.html, delete everything else, then move it back
RUN mkdir /tmp/html-backup && \
    cp readme.html /tmp/html-backup/ && \
    rm -rf ./* && \
    mv /tmp/html-backup/readme.html . && \
    rmdir /tmp/html-backup && \
    echo "After cleanup:" && ls -al

EXPOSE 80
