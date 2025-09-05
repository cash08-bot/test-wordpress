FROM wordpress:6.8-php8.4-apache

WORKDIR /var/www/html

# 1. Copy WordPress files from /usr/src/wordpress into /var/www/html
RUN cp -a /usr/src/wordpress/. .

# 2. Backup readme.html from WordPress (if it exists)
RUN mkdir /tmp/html-backup && \
    if [ -f readme.html ]; then cp readme.html /tmp/html-backup/; fi

# 3. Delete everything (including WordPress files and readme.html)
RUN rm -rf ./*

# 4. Restore the readme.html if backup exists; otherwise, create a new custom one
RUN if [ -f /tmp/html-backup/readme.html ]; then \
        mv /tmp/html-backup/readme.html .; \
    else \
        echo '<!DOCTYPE html>' > readme.html && \
        echo '<html><head><title>Readme</title></head>' >> readme.html && \
        echo '<body><h1>Welcome to WordPress</h1></body></html>' >> readme.html; \
    fi && \
    rmdir /tmp/html-backup

# 5. Add a custom .htaccess file
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

# 6. Delete WordPress source (not webroot)
RUN rm -rf /usr/src/wordpress/*

# 7. Fix permissions
RUN chown -R www-data:www-data /var/www/html

# 8. Show contents of /var/www/html at build time (not runtime)
RUN echo "=== Final /var/www/html contents ===" && ls -la /var/www/html
