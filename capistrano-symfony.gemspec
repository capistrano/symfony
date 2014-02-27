# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "capistrano-symfony"
  gem.version       = '0.1.0'
  gem.authors       = ["Peter Mitchell"]
  gem.email         = ["pete@peterjmit.com"]
  gem.description   = %q{Symfony specific Capistrano tasks}
  gem.summary       = %q{Capistrano Symfony - Easy deployment of Symfony 2 apps with Ruby over SSH}
  gem.homepage      = "http://github.com/peterjmit/capistrano-symfony"

  gem.files         = `git ls-files`.split($/)
  # no tests as of yet
  # gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.licenses      = ['MIT']

  gem.add_dependency 'capistrano', '~> 3.1'
  gem.add_dependency 'capistrano-composer', '~> 0.0.3'
  gem.add_dependency 'capistrano-file-permissions', '~> 0.0.1'
end
