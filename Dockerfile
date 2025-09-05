FROM wordpress:6.8-php8.4-apache

WORKDIR /var/www/html

# Step 1: Copy WordPress files manually
RUN cp -a /usr/src/wordpress/. .

# Step 2: Backup readme.html if it exists
RUN mkdir /tmp/html-backup && \
    if [ -f readme.html ]; then cp readme.html /tmp/html-backup/; fi

# Step 3: Delete all files in /var/www/html
RUN rm -rf ./*

# Step 4: Restore readme.html if it was backed up, or create a new one with proper HTML
RUN if [ -f /tmp/html-backup/readme.html ]; then \
        mv /tmp/html-backup/readme.html .; \
    else \
        echo '<!DOCTYPE html>' > readme.html && \
        echo '<html lang="en">' >> readme.html && \
        echo '<head>' >> readme.html && \
        echo '    <meta charset="UTF-8">' >> readme.html && \
        echo '    <meta name="viewport" content="width=device-width, initial-scale=1.0">' >> readme.html && \
        echo '    <title>Welcome to WordPress</title>' >> readme.html && \
        echo '    <style>' >> readme.html && \
        echo '        body { font-family: Arial, sans-serif; padding: 40px; background: #f9f9f9; }' >> readme.html && \
        echo '        h1 { color: #21759b; }' >> readme.html && \
        echo '        p { font-size: 18px; }' >> readme.html && \
        echo '    </style>' >> readme.html && \
        echo '</head>' >> readme.html && \
        echo '<body>' >> readme.html && \
        echo '    <h1>Welcome to WordPress</h1>' >> readme.html && \
        echo '    <p>This is a default readme file created by the Docker build process.</p>' >> readme.html && \
        echo '</body>' >> readme.html && \
        echo '</html>' >> readme.html; \
    fi && \
    rmdir /tmp/html-backup

# Step 5: Create updated .htaccess with standard WordPress rewrite rules
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

# Step 6: Remove WordPress source files to reduce image size
RUN rm -rf /usr/src/wordpress/*

# Step 7: Fix ownership so Apache can access files properly
RUN chown -R www-data:www-data /var/www/html

# Step 8: List files for verification
RUN echo "===== Final contents of /var/www/html =====" && ls -la /var/www/html
