# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'padrino-assets/version'

Gem::Specification.new do |s|
  s.name        = 'padrino-assets'
  s.version     = Padrino::Assets::VERSION
  s.authors     = ['Benjamin Bloch']
  s.email       = ['cirex@gamesol.org']
  s.homepage    = 'https://github.com/Cirex/padrino-assets'
  s.description = 'A Padrino plugin for using Sprockets to manage assets'
  s.summary     = s.description

  s.rubyforge_project = 'padrino-assets'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'sprockets', '~> 2.2.0'
  
  s.add_dependency 'padrino-core'
  s.add_dependency 'padrino-helpers'
end