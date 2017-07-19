load File.expand_path("../set_symfony_env.rake", __FILE__)

namespace :symfony do
  desc "Execute a provided symfony command"
  task :console, :command, :params, :role do |t, args|
    # ask only runs if argument is not provided
    ask(:cmd, "cache:clear")
    command = args[:command] || fetch(:cmd)
    role = args[:role] || fetch(:symfony_roles)
    params = args[:params] || ''

    on release_roles(role) do
      within release_path do
        symfony_console(command, params)
      end
    end

    Rake::Task[t.name].reenable
  end

  namespace :cache do
    desc "Run app/console cache:clear for the #{fetch(:symfony_env)} environment"
    task :clear do
      on release_roles(fetch(:symfony_deploy_roles)) do
        symfony_console "cache:clear"
      end
    end

    desc "Run app/console cache:warmup for the #{fetch(:symfony_env)} environment"
    task :warmup do
      on release_roles(fetch(:symfony_deploy_roles)) do
        symfony_console "cache:warmup"
      end
    end
  end

  namespace :assets do
    desc "Install assets"
    task :install do
      on release_roles(fetch(:symfony_deploy_roles)) do
        within release_path do
          symfony_console "assets:install", fetch(:assets_install_path) + ' ' + fetch(:assets_install_flags)
        end
      end
    end
  end

  desc "Create the cache directory"
  task :create_cache_dir do
    on release_roles(fetch(:symfony_deploy_roles)) do
      within release_path do
        if test "[ -d #{symfony_cache_path} ]"
          execute :rm, "-rf", symfony_cache_path
        end
        execute :mkdir, "-pv", fetch(:cache_path)
      end
    end
  end

  desc "Set user/group permissions on configured paths"
  task :set_permissions do
    if fetch(:permission_method) != false
      invoke "deploy:set_permissions:#{fetch(:permission_method).to_s}"
    end
  end

  desc "Clear non production controllers"
  task :clear_controllers do
    next unless any? :controllers_to_clear
    on release_roles(fetch(:symfony_deploy_roles)) do
      within symfony_web_path do
        execute :rm, "-f", *fetch(:controllers_to_clear)
      end
    end
  end

  desc "Build the bootstrap file"
  task :build_bootstrap do
    on release_roles(fetch(:symfony_deploy_roles)) do
      within release_path do
        if fetch(:symfony_directory_structure) == 2
          execute :php, build_bootstrap_path, fetch(:app_path)
        else
          execute :php, build_bootstrap_path, fetch(:var_path)
        end
      end
    end
  end

end

task :symfony => ["symfony:console"]
