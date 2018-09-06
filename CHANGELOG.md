# Capistrano Symfony 1.x Changelog


## `1.0.0`

No changes since RC3

## `1.0.0.rc3`

(No changelog provided.) See diff: See the diff: https://github.com/capistrano/symfony/compare/1.0.0.rc2...1.0.0.rc3

## `1.0.0.rc2`

https://github.com/capistrano/symfony/compare/1.0.0.rc2...1.0.0.rc1

* Ensure bootstrap.php is saved in `var/` when using Symfony 3 directory structure

## `1.0.0.rc1`

https://github.com/capistrano/symfony/compare/0.4.0...1.0.0.rc1

* Use file permissions gem v1
* Symfony 3 directory structure is on by default
* Remove `use_set_permission` variable
* Remove `web/uploads` as a default linked directory
* Remove support for Assetic (see: https://github.com/symfony/symfony-standard/pull/860)
* Support SensioLabsDistributionBundle 5 (#49)
* Support Symfony 3 directory structure (#31)
* `build_bootstrap_path` is now a DSL method
* `symfony_console` is now a DSL method (use instead of `invoke "symfony:console"`)
* Paths DSL file has been moved to `lib/capistrano/dsl/symfony.rb`
* Deprecated `symfony:command` task has been removed
* `webserver_user` variable has been removed (#40)
* Various typo fixes

### Contributors

Thanks to everyone who has filed an issue or submitted a fix

  * @kriswallsmith
  * @zaerl
  * @sandermarechal
  * @pborreli
  * @wideawake
  * @issei-m
  * @alafon
