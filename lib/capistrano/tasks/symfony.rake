module Capistrano
  class FileNotFound < StandardError
  end
end

namespace :deploy do
  desc "Create the cache directory"
  task :create_cache_dir do
    on roles :app do
      within release_path do
        if test "[ -d #{symfony_cache_path} ]"
          execute :rm, "-rf", symfony_cache_path
        end
        execute :mkdir, "-pv", fetch(:cache_path)
      end
    end
  end

  desc "Clear non production controllers"
  task :clear_controllers do
    next unless any? :controllers_to_clear
    on roles :app do
      within symfony_web_path do
        execute :rm, "-f", *fetch(:controllers_to_clear)
      end
    end
  end

  task :build_bootstrap do
    on roles :app do
      within release_path do
        # TODO: does this need to be configurable?
        execute :php, "./vendor/sensio/distribution-bundle/Sensio/Bundle/DistributionBundle/Resources/bin/build_bootstrap.php"
      end
    end
  end

  task :updating do
    invoke "deploy:create_cache_dir"

    if fetch(:use_set_permissions)
      invoke "deploy:set_permissions:#{fetch(:permission_method).to_s}"
    end
  end

  task :updated do
    invoke "deploy:build_bootstrap"
    invoke "symfony:cache:warmup"
  end

  after "deploy:updated", "deploy:clear_controllers"
  after "deploy:updated", "deploy:assets:install"
end
