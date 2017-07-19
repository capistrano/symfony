#
# Symfony defaults
#
set :symfony_env,  "prod"

set :symfony_directory_structure, 3
set :sensio_distribution_version, 5

# symfony-standard edition top-level directories
set :app_path, "app"
set :web_path, "web"
set :var_path, "var"
set :bin_path, "bin"

# Use closures for directories nested under the top level dirs, so that
# any changes to web/app etc do not require these to be changed also
set :app_config_path, -> { fetch(:app_path) + "/config" }
set :log_path, -> { fetch(:symfony_directory_structure) == 2 ? fetch(:app_path) + "/logs" : fetch(:var_path) + "/logs" }
set :cache_path, -> { fetch(:symfony_directory_structure) == 2 ? fetch(:app_path) + "/cache" : fetch(:var_path) + "/cache" }

# console
set :symfony_console_path, -> { fetch(:symfony_directory_structure) == 2 ?  fetch(:app_path) + '/console' : fetch(:bin_path) + "/console" }
set :symfony_console_flags, "--no-debug"

set :controllers_to_clear, ["app_*.php", "config.php"]

# assets
set :assets_install_path, fetch(:web_path)
set :assets_install_flags,  '--symlink'

#
# Capistrano defaults
#
set :linked_files, -> { [fetch(:app_config_path) + "/parameters.yml"] }
set :linked_dirs, -> { [fetch(:log_path)] }

#
# Configure capistrano/file-permissions defaults
#
set :file_permissions_paths, -> { fetch(:symfony_directory_structure) == 2 ? [fetch(:log_path), fetch(:cache_path)] : [fetch(:var_path)] }
# Method used to set permissions (:chmod, :acl, or :chown)
set :permission_method, false

# Role filtering
set :symfony_roles, :all
