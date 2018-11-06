# Capistrano::Symfony

Symfony 4 specific tasks for Capistrano v3 (inspired by [capifony][2]).

It leverages the following capistrano tasks to deploy a Symfony app

* https://github.com/capistrano/composer
* https://github.com/capistrano/file-permissions

## Version information

#### Version 1.x

This version is built for **Symfony 2 and 3**. 

Go to [Version 1 documentation](/../../tree/1.x). 

#### Version 2.x

This version is built for **Symfony 4**. 

You are currently on the Version 2 branch. 

## Installation

Specify your dependencies: 
```
# Gemfile
source 'https://rubygems.org'
gem 'capistrano',  '~> 3.11'
gem 'capistrano-symfony', '~> 2.0.0.pre.alfa2'
```

Install your dependencies: 
```
bundle install
```

When `capistrano` and `capistrano-symfony` is installed. Run the following command
to set up your local files:

```
cap install
```

Make Capistrano aware of `'capistrano/symfony' by require capistrano-symfony in your
new Capfile

```
# Capfile
require 'capistrano/symfony'

# If you use composer you might want this:
require 'capistrano/composer'
```

## Usage

```
cap staging deploy
cap production deploy
```

### Settings

If you are using a standard Symfony Flex application that follows the best practises 
then you do not need to change/add anything to your `deploy.rb` other than what is 
required from Capistrano.

We do however expose the following settings (shown with default evaluated values) 
that can be modified to suit your project. Please refer to `lib/capistrano/symfony/defaults.rb` 
to see exactly how the defaults are set up.


```ruby

# symfony-standard edition directories
set :bin_path, "bin"
set :config_path, "config"
set :var_path, "var"
set :web_path, "public"

# The next settings are lazily evaluated from the above values, so take care
# when modifying them
set :log_path, "var/log"
set :cache_path, "var/cache"

set :symfony_console_path, "bin/console"
set :symfony_console_flags, "--no-debug"

# asset management
set :assets_install_path, "public"
set :assets_install_flags,  '--symlink'

# Share files/directories between releases
set :linked_dirs, ["var/log"]
set :linked_files, []
# To use a .env file:
#set :linked_files, [".env"]

# Set correct permissions between releases, this is turned off by default
set :file_permissions_paths, ["var"]
set :permission_method, false

# Role filtering
set :symfony_roles, :all
set :symfony_deploy_roles, :all

# Add extra environment variables: 
set :default_env, {
 'APP_ENV' => 'prod'
 'SECRET' => 'foobar'
}
```

### Flow

capistrano-symfony hooks into the [flow][1] offered by capistrano. It adds to that flow like so

* `symfony:create_cache_dir`
* `symfony:set_permissions`
* `symfony:cache:warmup`

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
|   |__ symfony:make_console_executable
|__ deploy:updated
|   |__ symfony:cache:warmup
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

Set the `permission_method` variable to one of `:chmod`, `:acl`, or `:chgrp` in
your `deploy.rb` to handle the common scenario of a web user and the deploy user
being different.

Both will need access to the files/directories such as `var/cache` and `public/uploads`
(if you handle uploads). Set `file_permissions_users` to your webserver user

Example:

```
# deploy.rb

set :permission_method, :acl
set :file_permissions_users, ["nginx"]
set :file_permissions_paths, ["var", "public/uploads"]
```

**Note:** Using `:acl` requires that `setfacl` be available on your deployment target.
**Note:** If you are getting an error like `setfacl: Option -m: Invalid argument near character 3`,  
it means that the users in `file_permissions_users` do not exist on your deployment
target.



See [the symfony documentation](http://symfony.com/doc/current/book/installation.html#checking-symfony-application-configuration-and-setup)
and [the file permission capistrano plugin](https://github.com/capistrano/file-permissions) for reference.

### Integrated common tasks

The following common tasks are available:

* `symfony:assets:install`

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

If you want to execute a command on a host with a given role you can use the Capistrano
`on` DSL, additionally using `within` from Capistrano will change the directory

```ruby
namespace :deploy do
  task :migrate do
    on roles(:db) do
      symfony_console('doctrine:migrations:migrate', '--no-interaction')
    end
  end
end
```

### Using composer

If you use composer you can install `capistrano/composer`. Here are some short 
instructions. Read more at [capistrano/composer](https://github.com/capistrano/composer).

First run the following command to download the library: 

```
gem install capistrano-composer
```

Then make sure your Capfile includes the following: 

```
require 'capistrano/composer'
```

To download the composer.phar executable add the following to your `deploy.rb`:

```
# First define deploy target: 
set :deploy_to, "/home/sites/com.example"

# Install composer if it does not exist
SSHKit.config.command_map[:composer] = "php #{shared_path.join("composer.phar")}"

namespace :deploy do
  after :starting, 'composer:install_executable'
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
