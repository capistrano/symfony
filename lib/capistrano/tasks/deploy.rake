module Capistrano
  class FileNotFound < StandardError
  end
end

before 'deploy:updating', 'symfony:create_cache_dir'
before 'deploy:updating', 'symfony:set_permissions'
before 'deploy:updated', 'symfony:cache:warmup'
before 'deploy:updated', 'symfony:clear_controllers'
