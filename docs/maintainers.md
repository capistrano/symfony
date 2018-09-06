# Documentation for maintainers

Since this is a Ruby tool used by PHP programmers it might be a good idea to document
some things. 


## Making a release

Checklist for making a release: 

- Write changelog 
- Update version number in `capistrano-symfony.gemspec`
- Make a new release with GitHub 
- Build the gem with `gem build capistrano-symfony.gemspec`
- Push the gem to rubygems.org: `gem push capistrano-symfony-X.X.X.gem` 
- Add the `capistrano-symfony-X.X.X.gem` to the GitHub release 

