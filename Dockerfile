FROM wordpress:6.8-php8.4-apache

WORKDIR /var/www/html

# Step 1: Copy WordPress files into the web root
RUN cp -a /usr/src/wordpress/. .

# Step 2: Backup readme.html if it exists
RUN mkdir /tmp/html-backup && \
    if [ -f readme.html ]; then cp readme.html /tmp/html-backup/; fi

# Step 3: Delete everything in /var/www/html
RUN rm -rf ./*

# Step 4: Restore or create readme.html
RUN if [ -f /tmp/html-backup/readme.html ]; then \
        mv /tmp/html-backup/readme.html .; \
    else \
        echo '<!DOCTYPE html>' > readme.html && \
        echo '<html><head><title>Readme</title></head>' >> readme.html && \
        echo '<body><h1>Welcome to WordPress</h1></body></html>' >> readme.html; \
    fi && \
    rmdir /tmp/html-backup

# Step 5: Create a custom .htaccess
RUN echo '# BEGIN WordPress' > .htaccess && \
    echo '<IfModule mod_rewrite.c>' >> .htaccess && \
    echo 'RewriteEngine On' >> .htaccess && \
    echo 'RewriteBase /' >> .htaccess && \
    echo 'RewriteRule ^index\.php$ - [L]' >> .htaccess && \
    echo 'RewriteCond %{REQUEST_FILENAME} !-f' >> .htaccess && \
    echo 'RewriteCond %{REQUEST_FILENAME} !-d' >> .htaccess && \
    echo 'RewriteRule . /index.php [L]' >> .htaccess && \
    echo '</IfModule>' >> .htaccess && \
    echo '# END WordPress' >> .htaccess

# Step 6: Clean up source files to reduce image size
RUN rm -rf /usr/src/wordpress/*

# Step 7: Fix ownership
RUN chown -R www-data:www-data /var/www/html

# Step 8: Final listing of files in /var/www/html
RUN echo "=== Final /var/www/html contents ===" && ls -la /var/www/html
