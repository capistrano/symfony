# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "capistrano-symfony"
  gem.version       = '1.0.0'
  gem.authors       = ["Peter Mitchell"]
  gem.email         = ["pete@peterjmit.com"]
  gem.description   = %q{Symfony specific Capistrano tasks}
  gem.summary       = %q{Capistrano Symfony - Easy deployment of Symfony 2 & 3 apps with Ruby over SSH}
  gem.homepage      = "http://github.com/capistrano/capistrano-symfony"

  gem.files         = `git ls-files`.split($/)
  # no tests as of yet
  # gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.licenses      = ['MIT']

  gem.post_install_message = <<eos
  WARNING - This gem has switched repositories. This gem is now for the
  capistrano-symfony plugin located at https://github.com/capistrano/symfony.
  This package behaves differently from the previous, and the release versions
  have changed.

  The Big Brains Company and Thomas Tourlourat (@armetiz) kindly agreed to
  transfer the ownership of this gem over to the Capistrano organization. The
  previous repository can be found here https://github.com/TheBigBrainsCompany/capistrano-symfony
eos

  gem.add_dependency 'capistrano', '~> 3.1'
  gem.add_dependency 'capistrano-composer', '~> 0.0.3'
  gem.add_dependency 'capistrano-file-permissions', '~> 1.0'
end
