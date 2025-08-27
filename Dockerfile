FROM wordpress:6.8-php8.4-apache

# Copy WordPress files into /var/www/html (mimicking what the entrypoint does)
RUN cp -a /usr/src/wordpress/. /var/www/html/

WORKDIR /var/www/html

# Preserve readme.html, delete everything else, then move it back
RUN mkdir /tmp/html-backup && \
    cp readme.html /tmp/html-backup/ && \
    rm -rf ./* && \
    mv /tmp/html-backup/readme.html . && \
    rmdir /tmp/html-backup && \
    echo "After cleanup:" && ls -al

EXPOSE 80
