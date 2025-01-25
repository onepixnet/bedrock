#!/bin/bash

handle_error() {
    echo "❌ Error occurred: $1"
    exit 1
}

# Waiting for database initialization
echo "Hold tight! Waiting for the database to be ready... 🕒"
while ! wp db check --quiet; do
    echo "Still waiting for the database to respond... Patience is a virtue! 🙏"
    sleep 1
done
echo "The database is up and running. Let's keep rolling! 🚀"

# Load .env variables
if [ -f .env ]; then
    echo "Found the .env file. Loading environment variables... 📜"
    export $(grep -v '^#' .env | xargs)
    echo "Environment variables loaded successfully. Here they are: ⚡"

    while IFS= read -r line; do
        # Пропускаем строки, начинающиеся с #, пустые строки и строки без ключей
        if [[ $line != \#* && -n $line && $line == *=* && ${line%%=*} ]]; then
            var_name=$(echo "$line" | cut -d '=' -f 1)
            var_value=$(printenv "$var_name")
            echo "  - $var_name=$var_value"
        fi
    done < <(grep -v '^#' .env)
else
    handle_error "Couldn't find the .env file"
fi

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
else
    echo "WordPress is already installed. No need to fix what's not broken! 💪"
fi