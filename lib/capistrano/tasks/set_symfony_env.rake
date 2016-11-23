namespace :deploy do
  task :set_symfony_env do
    symfony_env = fetch(:symfony_env) || 'prod'

    fetch(:default_env).merge!(symfony_env: symfony_env)
    set :symfony_console_flags, fetch(:symfony_console_flags) + ' --env=' + symfony_env
  end
end

Capistrano::DSL.stages.each do |stage|
  after stage, 'deploy:set_symfony_env'
end
