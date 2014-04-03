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

set :composer_install_flags, "--no-dev --verbose --prefer-dist --optimize-autoloader --no-progress"

set :symfony_console_path, fetch(:app_path) + "/console"
set :symfony_console_flags, "--no-debug"

# Assets install
set :assets_install_path,   fetch(:web_path)

fetch(:default_env).merge!(symfony_env: fetch(:symfony_env))
