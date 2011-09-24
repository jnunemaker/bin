# encoding: UTF-8
require File.expand_path('../lib/bin/version', __FILE__)

Gem::Specification.new do |s|
  s.name         = 'bin'
  s.version      = Bin::Version
  s.platform     = Gem::Platform::RUBY
  s.authors      = ['John Nunemaker']
  s.email        = ['nunemaker@gmail.com']
  s.homepage     = 'http://github.com/jnunemaker/bin'
  s.summary      = 'ActiveSupport MongoDB Cache store.'
  s.description  = 'ActiveSupport MongoDB Cache store.'

  s.add_dependency 'mongo',         '~> 1.3.0'
  s.add_dependency 'activesupport', '>= 3.0.0', '< 3.2.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end