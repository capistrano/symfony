UPGRADING FROM 0.x to 1.0
=========================

* Add the following to your `deploy.rb`:
```ruby
# Role filtering
set :symfony_roles, :all
set :symfony_deploy_roles, :all
```
