namespace :assets do
  desc 'Compiles all assets'
  task :precompile do
    environment = Padrino::Assets.environment
    manifest = Padrino::Assets.manifest
    apps = Padrino.mounted_apps
    apps.each do |app|
      app = app.app_obj

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
    end
  end
end