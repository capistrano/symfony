module Capistrano
  class FileNotFound < StandardError
  end
end

namespace :deploy do

  task :updating do
    invoke "symfony:create_cache_dir"
    invoke "symfony:set_permissions"
    invoke "symfony:make_console_executable"
  end

  task :updated do
    invoke "symfony:cache:warmup"
    invoke "symfony:clear_controllers"
  end

end
