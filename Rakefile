$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'padrino-assets/version'

require 'rake'
require 'yard'
require 'rspec'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |task|
  task.pattern = 'spec/**/*_spec.rb'
end

YARD::Rake::YardocTask.new

task :build do
  `gem build padrino-assets.gemspec`
end

task :install => :build do
  `gem install padrino-assets-#{Padrino::Assets::VERSION}.gem`
end

desc 'Releases the current version into the wild'
task :release => :build do
  `git tag -a v#{Padrino::Assets::VERSION} -m "Version #{Padrino::Assets::VERSION}"`
  `gem push padrino-assets-#{Padrino::Assets::VERSION}.gem`
  `git push --tags`
end

task :default => :spec