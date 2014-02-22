namespace :assets do
  desc 'Deletes all compiled assets'
  task :clobber => :environment do
    manifest = Padrino::Assets.manifest
    manifest.clobber
  end
end