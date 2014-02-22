namespace :assets do
  desc 'Compresses all compiled assets'
  task :compress => :environment do
    environment = Padrino::Assets.environment
    manifest = Padrino::Assets.manifest

    manifest.assets.each do |asset, digested_asset|
      if asset = environment[asset]
        compressed_asset = File.join(manifest.dir, digested_asset)
        asset.write_to(compressed_asset + '.gz') if compressed_asset =~ /\.(?:css|html|js|svg|txt|xml)$/
      end
    end
  end
end