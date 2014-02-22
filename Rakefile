require_relative 'lib/padrino-assets/version'

require 'rake'
require 'yard'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |task|
  task.pattern = 'spec/**/*_spec.rb'
end

YARD::Rake::YardocTask.new

def gem_name
  "padrino-assets-#{Padrino::Assets.version}.gem"
end

task :build do
  `gem build padrino-assets.gemspec`
end

task :install => :build do
  `gem install #{gem_name}`
end

desc 'Releases the current version into the wild'
task :release => :install do
  `git tag -a v#{Padrino::Assets.version} -m "Version #{Padrino::Assets.version}"`
  `gem push #{gem_name}`
  `git push --tags`
end

task :uninstall do
  `gem uninstall #{gem_name} --force --all`
end

task :cleanup do
  Dir['*.gem'].each do |file|
    File.delete(file)
  end
end

task :default => :spec