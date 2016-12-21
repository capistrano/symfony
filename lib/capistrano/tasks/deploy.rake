module Capistrano
  class FileNotFound < StandardError
  end
end

after 'deploy:updating', 'symfony:create_cache_dir'
after 'deploy:updating', 'symfony:set_permissions'
before 'deploy:updated', 'symfony:cache:warmup'
before 'deploy:updated', 'symfony:clear_controllers'
