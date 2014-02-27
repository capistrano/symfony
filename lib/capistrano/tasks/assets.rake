namespace :deploy do
  namespace :assets do
    task :install do
      invoke "symfony:command", "assets:install", fetch(:assets_install_path)
    end
  end
end
