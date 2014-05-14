require "capistrano/file-permissions"
require "capistrano/composer"
require "capistrano/symfony/dsl"
require "capistrano/symfony/symfony"

# Core tasks for deploying symfony
load File.expand_path("../tasks/deploy.rake", __FILE__)

namespace :load do
  task :defaults do
    load "capistrano/symfony/defaults.rb"
  end
end
