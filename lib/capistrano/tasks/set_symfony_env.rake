namespace :deploy do
  task :set_symfony_env do
    fetch(:default_env).merge!(symfony_env: fetch(:symfony_env) || 'prod')
  end
end

Capistrano::DSL.stages.each do |stage|
  after stage, 'deploy:set_symfony_env'
end
