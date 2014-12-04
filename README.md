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

# Method used to set permissions (:chmod, :acl, or :chgrp)
set :permission_method,     false

# Execute set permissions
set :use_set_permissions,   false

# Symfony console path
set :symfony_console_path, fetch(:app_path) + "/console"

# Symfony console flags
set :symfony_console_flags, "--no-debug"

# Assets install path
set :assets_install_path,   fetch(:web_path)

# Assets install flags
set :assets_install_flags,  '--symlink'

# Assetic dump flags
set :assetic_dump_flags,  ''

fetch(:default_env).merge!(symfony_env: fetch(:symfony_env))
```

### Flow

capistrano-symfony hooks into the [flow][1] offered by capistrano. It adds to that flow like so

* ```symfony:create_cache_dir```
* ```symfony:set_permissions```
* ```symfony:cache:warmup```
* ```symfony:clear_controllers```

```
deploy
|__ deploy:starting
|   |__ [before]
|   |   |__ deploy:ensure_stage
|   |   |__ deploy:set_shared_assets
|   |__ deploy:check
|__ deploy:started
|__ deploy:updating
|   |__ git:create_release
|   |__ deploy:symlink:shared
|   |__ symfony:create_cache_dir
|   |__ symfony:set_permissions
|__ deploy:updated
|   |__ symfony:cache:warmup
|   |__ symfony:clear_controllers
|__ deploy:publishing
|   |__ deploy:symlink:release
|   |__ deploy:restart
|__ deploy:published
|__ deploy:finishing
|   |__ deploy:cleanup
|__ deploy:finished
    |__ deploy:log_revision
```

### Integrated common tasks

The folowing common tasks are already integrated:
* ```symfony:assets:install```
* ```symfony:assetic:dump```

So you can use them with hooks like this:
```ruby
  after 'deploy:updated',   'symfony:assets:install'
  after 'deploy:updated',   'symfony:assetic:dump'
```

### Using the Symfony console

A task wrapping the symfony console is provided, making it easy to create tasks
that call console methods.

For example if you have installed the [DoctrineMigrationsBundle][3] in your
project you may want to run migrations during a deploy.

```ruby
namespace :deploy do
  task :migrate do
    invoke 'symfony:console', 'doctrine:migrations:migrate', '--no-interaction'
  end
end
```

You can also apply role filter on your commands by passing a fourth parameter.

```ruby
namespace :deploy do
  task :migrate do
    invoke 'symfony:console', 'doctrine:migrations:migrate', '--no-interaction', 'db'
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
