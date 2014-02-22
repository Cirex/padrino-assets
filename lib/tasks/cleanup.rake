namespace :assets do
  desc 'Removes backups for existing assets'
  task :cleanup, [:quanity] => :environment do |task, args|
    quanity  = args['quanity'] || 2
    manifest = Padrino::Assets.manifest
    manifest.cleanup(quanity)
  end
end