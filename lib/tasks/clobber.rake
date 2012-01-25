# encoding: utf-8
namespace :assets do
  desc 'Deletes all compiled assets'
  task :clobber do
    manifest = Padrino::Assets.manifest
    manifest.clobber
  end
end