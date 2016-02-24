require "capistrano/dsl/symfony"
self.extend Capistrano::DSL::Symfony

SSHKit::Backend::Netssh.send(:include, Capistrano::DSL::Symfony)

require "capistrano/file-permissions"
require "capistrano/composer"
require "capistrano/symfony/symfony"

# Core tasks for deploying symfony
load File.expand_path("../tasks/deploy.rake", __FILE__)

namespace :load do
  task :defaults do
    load "capistrano/symfony/defaults.rb"
  end
end
