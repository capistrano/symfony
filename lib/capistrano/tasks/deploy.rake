module Capistrano
  class FileNotFound < StandardError
  end
end

namespace :deploy do

  task :updating do
    invoke "symfony:create_cache_dir"
  end

  task :updated do
    invoke "symfony:cache:warmup"
    invoke "symfony:clear_controllers"
    invoke "symfony:set_permissions"
  end

end
