#
# Symfony defaults
#
set :symfony_env,  "prod"

# symfony-standard edition top-level directories
set :bin_path, "bin"
set :config_path, "config"
set :var_path, "var"
set :web_path, "public"

# Use closures for directories nested under the top level dirs, so that
# any changes to web/app etc do not require these to be changed also
set :log_path, -> { fetch(:var_path) + "/logs" }
set :cache_path, -> { fetch(:var_path) + "/cache" }

# PHP executable used to run commands
set :php, "php"

# console
set :symfony_console_path, -> { fetch(:bin_path) + "/console" }
set :symfony_console_flags, "--no-debug"

# assets
set :assets_install_path, fetch(:web_path)
set :assets_install_flags,  '--symlink'

#
# Capistrano defaults
#
set :linked_files, -> { [] }
set :linked_dirs, -> { [fetch(:log_path)] }

#
# Configure capistrano/file-permissions defaults
#
set :file_permissions_paths, -> { [fetch(:var_path)] }
# Method used to set permissions (:chmod, :acl, or :chown)
set :permission_method, false

# Role filtering
set :symfony_roles, :all
set :symfony_deploy_roles, :all
