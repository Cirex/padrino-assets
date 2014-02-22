namespace :assets do
  desc 'Compiles all assets'
  task :precompile => :environment do
    environment = Padrino::Assets.environment
    manifest = Padrino::Assets.manifest
    apps = Padrino.mounted_apps
    apps.each do |app|
      app = app.app_obj

      next unless app.extensions.include?(Padrino::Assets)

      app.precompile_assets.each do |path|
        environment.each_logical_path.each do |logical_path|
          case path
          when Regexp
            next unless path.match(logical_path)
          when Proc
            next unless path.call(logical_path)
          else
            next unless File.fnmatch(path.to_s, logical_path)
          end

          manifest.compile(logical_path)
        end
      end

      if app.compress_assets?
        Rake::Task['assets:compress'].invoke
      end
    end
  end
end