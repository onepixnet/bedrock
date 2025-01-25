# Bedrock for OnePix (BOP)

A fork of [roots/bedrock](https://github.com/roots/bedrock) tailored for [OnePix](https://github.com/onepixnet).

This fork is designed as a foundation for developing WordPress themes and plugins. All project code should be located in the `web/app/{plugins,themes}` directory.

A single BOP-based project can include multiple related themes and plugins under development. In such cases, BOP serves as the foundation for a monorepo. Component code can be included directly in the monorepo or added as Git submodules.

## Differences from the Original

- GitHub Actions have been removed since we use GitLab CI.
- Docker has been added for easy local setup.
- The Pint package has been removed because each theme or plugin under development includes its own static analysis tools.

## Getting Started

### Basic Setup

1. Run `composer create-project onepix/bedrock` to install BOP.
2. Create an `.env` file by running `cp .env.example .env`.
3. Update the required variables in the `.env` file.
4. Start Docker with `docker-compose up -d`.

### Adding a Theme Under Development

1. Copy your theme directory into `web/app/themes`, or start developing a theme based on our template [onepix/wordpress-template](https://github.com/onepixnet/wordpress-template).
2. Add the theme directory to the `.gitignore` file under the section "Themes under development".
3. Commit the new code to the monorepo.

### Adding a Plugin Under Development

1. Copy your plugin directory into `web/app/plugins`, or start developing a plugin based on our template [onepix/wordpress-template](https://github.com/onepixnet/wordpress-template).
2. Add the plugin directory to the `.gitignore` file under the section "Plugins under development".
3. Commit the new code to the monorepo.

### Adding Plugins as Dependencies

To add plugins as project dependencies, use Composer and [WPackagist](https://wpackagist.org/). WPackagist is already configured in the project's `composer.json`. All plugins installed this way will automatically be placed in the `web/app/plugins` directory.

You can find available plugins on the [WPackagist search page](https://wpackagist.org/search). For example, to install the WooCommerce plugin, run: `composer require wpackagist-plugin/woocommerce`

This will:
1. Add the plugin to `composer.json`.
2. Install it.
3. Place it in the `web/app/plugins/woocommerce` directory.

### Adding Themes as Dependencies

The process for adding themes is the same as for plugins. By default, the latest official WordPress theme is installed, but you can choose another theme if you're not developing your own.

This is especially useful when developing WooCommerce plugins. For example, you can install the official WooCommerce theme "Storefront" alongside the WooCommerce plugin by running: `composer require wpackagist-theme/storefront`
