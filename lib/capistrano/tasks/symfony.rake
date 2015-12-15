load File.expand_path("../set_symfony_env.rake", __FILE__)

namespace :symfony do
  desc "Execute a provided symfony command"
  task :console, :command, :params, :role do |t, args|
    # ask only runs if argument is not provided
    ask(:cmd, "cache:clear")
    command = args[:command] || fetch(:cmd)
    role = args[:role] || :all
    params = args[:params] || ''

    on release_roles(role) do
      within release_path do
        execute :php, fetch(:symfony_console_path), command, params, fetch(:symfony_console_flags)
      end
    end

    Rake::Task[t.name].reenable
  end

  task :command, :command_name, :flags do |t, args|
    on roles(:all) do
      warn "The task symfony:command is deprecated in favor of symfony:console"
      invoke "symfony:console", args[:command_name], args[:flags]
    end
  end


  namespace :cache do
    desc "Run app/console cache:clear for the #{fetch(:symfony_env)} environment"
    task :clear do
      invoke "symfony:console", "cache:clear"
    end

    desc "Run app/console cache:warmup for the #{fetch(:symfony_env)} environment"
    task :warmup do
      invoke "symfony:console", "cache:warmup"
    end
  end

  namespace :assets do
    desc "Install assets"
    task :install do
      invoke "symfony:console", "assets:install", fetch(:assets_install_path) + ' ' + fetch(:assets_install_flags)
    end
  end

  namespace :assetic do
    desc "Dump assets with Assetic"
    task :dump do
      invoke "symfony:console", "assetic:dump", fetch(:assetic_dump_flags)
    end
  end

  desc "Create the cache directory"
  task :create_cache_dir do
    on release_roles :all do
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
    on release_roles :all do
      if fetch(:use_set_permissions)
        invoke "deploy:set_permissions:#{fetch(:permission_method).to_s}"
      end
    end
  end

  desc "Clear non production controllers"
  task :clear_controllers do
    next unless any? :controllers_to_clear
    on release_roles :all do
      within symfony_web_path do
        execute :rm, "-f", *fetch(:controllers_to_clear)
      end
    end
  end

  desc "Build the bootstrap file"
  task :build_bootstrap do
    on release_roles :all do
      within release_path do
        execute :php, sensio_distribution_bootstrap_path, fetch(:app_path)
      end
    end
  end

end

task :symfony => ["symfony:console"]
