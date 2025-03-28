#!/bin/bash

handle_error() {
    echo "❌ Error occurred: $1"
    exit 1
}

# Checking if Composer dependencies need to be installed
echo "Let me check if the Composer dependencies need to be installed... 🔍"
if [ ! -f "vendor/autoload.php" ]; then
    if [ "$WP_ENV" == "development" ]; then
        echo "You're in development mode. Running regular composer install... 🚧"
        composer install
    else
        echo "You're in production mode. Running optimized composer install... ⚡"
        composer install --optimize-autoloader --no-dev
    fi
else
    echo "Dependencies are already installed. No need to reinstall. ✅"
fi

# Waiting for database initialization
echo "Hold tight! Waiting for the database to be ready... 🕒"
while ! wp db check --quiet; do
    echo "Still waiting for the database to respond... Patience is a virtue! 🙏"
    sleep 1
done
echo "The database is up and running. Let's keep rolling! 🚀"

# Install WordPress if it is not installed yet
if ! wp core is-installed 2>/dev/null; then
    echo "Installing WordPress... This is where the magic happens! ✨"

    wp core install \
        --url="$WP_HOME" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email
    echo "WordPress installation complete. Let's get this party started! 🎉"

    echo "Installing site for ${WP_ENV} environment"
    bash "bin/init_site_${WP_ENV}.sh"
else
    echo "WordPress is already installed. No need to fix what's not broken! 💪"
fi

debug_log="/var/www/html/web/app/debug.log"
if [ ! -f "$debug_log" ]; then
    touch "$debug_log"
    echo "File $debug_log created.🚀"
fi

echo "Write rules to $debug_log added.🎉"
chown www-data:www-data "$debug_log"
chmod 664 "$debug_log"

TIMEZONE=$(php -r 'echo date_default_timezone_get();')
wp option update timezone_string "$TIMEZONE"
echo "Timezone updated to $TIMEZONE successfully! 🎯"

CRON_COMMAND="* * * * * php /var/www/html/web/wp/wp-cron.php > /dev/null 2>&1"
if (crontab -l 2>/dev/null | grep -F "$CRON_COMMAND"); then
    echo "Cron job is already registered! ✅"
else
    if (crontab -l 2>/dev/null; echo "$CRON_COMMAND") | crontab -; then
        echo "Cron job registered successfully! 🎉"
    else
        echo "Failed to register the cron job! ❌"
    fi
fi