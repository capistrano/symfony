# Capistrano::Symfony

Symfony 2 (standard edition) specific tasks for Capistrano v3
(inspired by [capifony][2])

It leverages the following capistrano tasks to deploy a Symfony app

* https://github.com/capistrano/composer
* https://github.com/capistrano/file-permissions

## Installation

```
# Gemfile
gem 'capistrano',  '~> 3.1'
gem 'capistrano-symfony', '~> 0.1', :github => 'capistrano/symfony'
```

## Usage

Require capistrano-symfony in your cap file

```
# Capfile
require 'capistrano/symfony'
```

### Settings

capistrano-symfony exposes the following settings (displayed with defaults):

```ruby
# Symfony environment
set :symfony_env,  "prod"

# Symfony application path
set :app_path,              "app"

# Symfony web path
set :web_path,              "web"

# Symfony log path
set :log_path,              fetch(:app_path) + "/logs"

# Symfony cache path
set :cache_path,            fetch(:app_path) + "/cache"

# Symfony config file path
set :app_config_path,       fetch(:app_path) + "/config"

# Controllers to clear
set :controllers_to_clear, ["app_*.php"]

# Files that need to remain the same between deploys
set :linked_files,          []

# Dirs that need to remain the same between deploys (shared dirs)
set :linked_dirs,           [fetch(:log_path), fetch(:web_path) + "/uploads"]

# Dirs that need to be writable by the HTTP Server (i.e. cache, log dirs)
set :file_permissions_paths,         [fetch(:log_path), fetch(:cache_path)]

# Name used by the Web Server (i.e. www-data for Apache)
set :webserver_user,        "www-data"

# Method used to set permissions (:chmod, :acl, or :chown)
set :permission_method,     false

# Execute set permissions
set :use_set_permissions,   false

set :composer_install_flags, "--no-dev --no-scripts --verbose --prefer-dist --optimize-autoloader --no-progress"

set :symfony_console_path, fetch(:app_path) + "/console"
set :symfony_console_flags, "--no-debug"

# Assets install
set :assets_install_path,   fetch(:web_path)
```

### Flow

capistrano-symfony hooks into the [flow][1] offered by capistrano. It adds
to that flow like so

```
deploy
  deploy:starting
    [before]
      deploy:ensure_stage
      deploy:set_shared_assets
    deploy:check
  deploy:started
  deploy:updating
    git:create_release
    deploy:symlink:shared
    deploy:create_cache_dir
    deploy:set_permissions:(acl|chmod|chgrp) # optional
  deploy:updated
    deploy:build_bootstrap
    symfony:cache:warmup
    [after]
      deploy:clear_controllers
      deploy:assets:install
  deploy:publishing
    deploy:symlink:release
    deploy:restart
  deploy:published
  deploy:finishing
    deploy:cleanup
  deploy:finished
    deploy:log_revision
```

### Using the Symfony console

A task wrapping the symfony console is provided, making it easy to create tasks
that call console methods.

For example if you have installed the [DoctrineMigrationsBundle][3] in your
project you may want to run migrations during a deploy.

```ruby
namespace :deploy do
  task :migrate do
    invoke 'symfony:command', 'doctrine:migrations:migrate', '--no-interaction'
  end
end
```

[1]: http://capistranorb.com/documentation/getting-started/flow/
[2]: http://capifony.org/
[3]: http://symfony.com/doc/current/bundles/DoctrineMigrationsBundle/index.html

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
