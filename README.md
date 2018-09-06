# Capistrano::Symfony

Symfony 2 (standard edition) specific tasks for Capistrano v3 (inspired by [capifony][2]).

It leverages the following capistrano tasks to deploy a Symfony app

* https://github.com/capistrano/composer
* https://github.com/capistrano/file-permissions

## Installation

```
# Gemfile
gem 'capistrano',  '~> 3.4'
gem 'capistrano-symfony', '~> 1.0.0'
```

## Usage

Require capistrano-symfony in your cap file

```
# Capfile
require 'capistrano/symfony'
```


### Settings

If you are using an un-modified symfony-standard edition, version 3 then you do not need to change/add anything to your `deploy.rb` other than what is required from Capistrano.

We do however expose the following settings (shown with default evaluated values) that can be modified to suit your project. Please refer to `lib/capistrano/symfony/defaults.rb` to see exactly how the defaults are set up.


```ruby
# Symfony console commands will use this environment for execution
set :symfony_env,  "prod"

# Set this to 2 for the old directory structure
set :symfony_directory_structure, 3
# Set this to 4 if using the older SensioDistributionBundle
set :sensio_distribution_version, 5

# symfony-standard edition directories
set :app_path, "app"
set :web_path, "web"
set :var_path, "var"
set :bin_path, "bin"

# The next 3 settings are lazily evaluated from the above values, so take care
# when modifying them
set :app_config_path, "app/config"
set :log_path, "var/logs"
set :cache_path, "var/cache"

set :symfony_console_path, "bin/console"
set :symfony_console_flags, "--no-debug"

# Remove app_dev.php during deployment, other files in web/ can be specified here
set :controllers_to_clear, ["app_*.php", "config.php"]

# asset management
set :assets_install_path, "web"
set :assets_install_flags,  '--symlink'

# Share files/directories between releases
set :linked_files, []
set :linked_dirs, ["var/logs"]

# Set correct permissions between releases, this is turned off by default
set :file_permissions_paths, ["var"]
set :permission_method, false

# Role filtering
set :symfony_roles, :all
```

#### Using this plugin with the old Symfony 2 directory structure and SensioDistributionBundle <= 4

Add the following to `deploy.rb` to use the old directory structure

```
# deploy.rb
set :symfony_directory_structure, 2
set :sensio_distribution_version, 4
```

If you are upgrading this gem and have modified `linked_dirs` or "advanced" variables such as `log_path` then you will need to update those accordingly

### Flow

capistrano-symfony hooks into the [flow][1] offered by capistrano. It adds to that flow like so

* `symfony:create_cache_dir`
* `symfony:set_permissions`
* `symfony:cache:warmup`
* `symfony:clear_controllers`

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

### File permissions

Set the `permission_method` variable to one of `:chmod`, `:acl`, or `:chgrp` in your `deploy.rb` to handle the common scenario of a web user and the deploy user being different.

Both will need access to the files/directories such as `var/cache` and `web/uploads` (if you handle uploads). Set `file_permissions_users` to your webserver user

Example:

```
# deploy.rb

set :permission_method, :acl
set :file_permissions_users, ["nginx"]
set :file_permissions_paths, ["var", "web/uploads"]
```

Please note that `:acl` requires that `setfacl` be available on your deployment target

See [the symfony documentation](http://symfony.com/doc/current/book/installation.html#checking-symfony-application-configuration-and-setup) and [the file permission capistrano plugin](https://github.com/capistrano/file-permissions) for reference

### Integrated common tasks

The following common tasks are available:

* `symfony:assets:install`
* `symfony:build_bootstrap` - useful if you disable composer

So you can use them with hooks in your project's `deploy.rb` like this:

```ruby
after 'deploy:updated', 'symfony:assets:install'
before 'deploy:updated', 'symfony:build_bootstrap'
```

### Using the Symfony console

A task wrapping the symfony console is provided, making it easy to create tasks
that call console methods.

For example if you have installed the [DoctrineMigrationsBundle][3] in your
project you may want to run migrations during a deploy.

```ruby
namespace :deploy do
  task :migrate do
    symfony_console('doctrine:migrations:migrate', '--no-interaction')
  end
end
```

If you want to execute a command on a host with a given role you can use the Capistrano `on` DSL, additionally using `within` from Capistrano will change the directory

```ruby
namespace :deploy do
  task :migrate do
    on roles(:db) do
      symfony_console('doctrine:migrations:migrate', '--no-interaction')
    end
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
