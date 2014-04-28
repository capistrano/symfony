namespace :deploy do
  namespace :assets do
    task :install do
      on release_roles :all do
        within release_path do
          execute :php, fetch(:symfony_console_path), "assets:install", fetch(:assets_install_path)
        end
      end
    end
  end
end
