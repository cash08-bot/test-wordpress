FROM wordpress:6.8-php8.4-apache

# Step 1: Copy WordPress files manually
RUN cp -a /usr/src/wordpress/. /var/www/html/ && \
    echo "After copying WordPress files:" && ls -al /var/www/html

WORKDIR /var/www/html

# Step 2: Backup readme.html, delete everything else, restore readme.html
RUN mkdir /tmp/html-backup && \
    cp readme.html /tmp/html-backup/ && \
    echo "After backing up readme.html:" && ls -al /var/www/html && \
    rm -rf ./* && \
    echo "After deleting all files:" && ls -al /var/www/html && \
    mv /tmp/html-backup/readme.html . && \
    rmdir /tmp/html-backup && \
    echo "After restoring readme.html:" && ls -al /var/www/html

# Step 3: Modify the existing .htaccess — add 'Require all granted'
RUN sed -i '/# BEGIN WordPress/a Require all granted' .htaccess && \
    echo "Updated .htaccess:" && cat .htaccess

# Step 4: Remove WordPress source to prevent runtime restore
RUN rm -rf /usr/src/wordpress/* && \
    echo "After removing /usr/src/wordpress files:" && ls -al /usr/src/wordpress

EXPOSE 80

CMD ["apache2-foreground"]
