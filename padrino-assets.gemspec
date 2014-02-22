require_relative 'lib/padrino-assets/version'

Gem::Specification.new do |spec|
  spec.name          = 'padrino-assets'
  spec.version       = Padrino::Assets.version
  spec.authors       = ['Benjamin Bloch']
  spec.email         = ['cirex@aethernet.org']
  spec.homepage      = 'https://github.com/Cirex/padrino-assets'
  spec.license       = 'MIT'
  spec.description   = 'A plugin for the Padrino web framework which uses Sprockets to manage and compile assets'
  spec.summary       = spec.description

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r(/bin/)) { |file| File.basename(file) }
  spec.test_files    = spec.files.grep(%r(/spec/))
  spec.require_paths = ['lib']

  private_key = File.expand_path('~/keys/gem-private.pem')

  if File.exist?(private_key)
    spec.signing_key = private_key
    spec.cert_chain  = ['padrino-assets.pem']
  end

  spec.add_dependency 'sprockets', '~> 2.11'
  spec.add_dependency 'padrino-core'
  spec.add_dependency 'padrino-helpers'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '>= 2.0.0'
  spec.add_development_dependency 'rspec-html-matchers'
  spec.add_development_dependency 'yard'

  spec.required_ruby_version = '>= 1.9.3'
end