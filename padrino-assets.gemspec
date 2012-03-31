# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'padrino-assets/version'

Gem::Specification.new do |s|
  s.name        = 'padrino-assets'
  s.version     = Padrino::Assets::VERSION
  s.authors     = ['Benjamin Bloch']
  s.email       = ['cirex@gamesol.org']
  s.homepage    = 'https://github.com/Cirex/padrino-assets'
  s.description = 'A plugin for the Padrino web framework which uses Sprockets to manage and compile assets'
  s.summary     = s.description

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'sprockets', '~> 2.4.0'
  s.add_dependency 'padrino-core'
  s.add_dependency 'padrino-helpers'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '>= 2.0.0'
  s.add_development_dependency 'rspec-html-matchers'
  s.add_development_dependency 'yard'
end