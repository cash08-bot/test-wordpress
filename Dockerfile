FROM wordpress:6.8-php8.4-apache

# Copy WordPress files manually
RUN cp -a /usr/src/wordpress/. /var/www/html/

WORKDIR /var/www/html

# Preserve readme.html, delete everything else, then move it back
RUN mkdir /tmp/html-backup && \
    cp readme.html /tmp/html-backup/ && \
    rm -rf ./* && \
    mv /tmp/html-backup/readme.html . && \
    rmdir /tmp/html-backup && \
    echo "After cleanup:" && ls -al

# Prevent WordPress from re-copying files at runtime
RUN rm -rf /usr/src/wordpress/*

EXPOSE 80
