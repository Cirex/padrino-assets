require 'padrino-core'
require 'padrino-helpers'

FileSet.glob_require('padrino-assets/**/*.rb', __FILE__)

module Padrino
  module Assets
    class << self
      ##
      # Returns a list of paths Sprockets will use in order to find assets used by the project
      #
      # @return [Array]
      #   List of assets paths
      #
      # @example
      #   Padrino::Assets.load_paths << Padrino.root('vendor', '**', 'assets')
      #
      # @since 0.1.0
      # @api public
      def load_paths
        @_load_paths ||= ['app/assets/**', 'lib/assets/**'].map do |file|
          Dir[Padrino.root(file)]
        end.flatten
      end

      ##
      # Returns the configured Sprockets environment
      #
      # @return [Sprockets::Environment]
      #   Sprockets environment
      #
      # @since 0.1.0
      # @api public
      def environment
        @_environment
      end

      ##
      # Returns a compiled manifest of our assets
      #
      # @return [Sprockets::Manifest]
      #   Sprockets manifest
      #
      # @since 0.1.0
      # @api public
      def manifest
        @_manifest
      end

      # @private
      def registered(app)
        app.helpers Helpers
        app.set :assets_prefix,   '/assets'
        app.set :assets_version,  1.0
        app.set :assets_host,     nil
        app.set :compress_assets, true
        app.set :js_compressor,   nil
        app.set :css_compressor,  nil
        app.set :index_assets,    -> { app.environment == :production }
        app.set :manifest_file,   -> { File.join(app.public_folder, app.assets_prefix, 'manifest.json') }
        app.set :precompile_assets,  [ /^.+\.(?!js|css).+$/i, /^application\.(js|css)$/i ]

        require 'sprockets'

        Padrino.after_load do
          @_environment = Sprockets::Environment.new(app.root) do |environment|
            environment.logger  = app.logger
            environment.version = app.assets_version
            if defined?(Padrino::Cache)
              if app.respond_to?(:caching) && app.caching?
                environment.cache = app.cache
              end
            end

            if app.compress_assets?
              environment.js_compressor  = app.js_compressor
              environment.css_compressor = app.css_compressor
            end
          end

          load_paths.each { |path| environment.append_path(path) }

          @_environment = environment.index if app.index_assets?
          @_manifest = Sprockets::Manifest.new(environment, app.manifest_file)
        end

        Padrino::Tasks.files << Dir[File.dirname(__FILE__) + '/tasks/**/*.{rake,rb}']
      end
    end
  end
end