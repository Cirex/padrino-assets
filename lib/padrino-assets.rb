# encoding: utf-8
require 'padrino-core'
require 'padrino-helpers'

FileSet.glob_require('padrino-assets/**/*.rb', __FILE__)

module Padrino
  module Assets
    class << self
      ###
      # Returns a list of paths Sprockets will use in order to find assets used by the project
      #
      # @return [Array]
      #   List of assets paths
      #
      # @example
      #   Padrino::Assets.load_paths << Dir[Padrino.root('vendor', '**', 'assets')]
      #
      # @since 0.1.0
      # @api public
      def load_paths
        @_load_paths ||= ['app/assets/**', 'lib/assets/**'].map do |directory|
          Dir[Padrino.root(directory)]
        end.flatten
      end

      ###
      # Returns the configured Sprockets environment
      #
      # @return [Sprockets::Environment]
      #   Sprockets environment
      #
      # @see https://github.com/sstephenson/sprockets/blob/master/lib/sprockets/environment.rb
      #
      # @since 0.1.0
      # @api public
      def environment
        @_environment
      end

      ###
      # Returns a compiled manifest of our assets
      #
      # @return [Sprockets::Manifest]
      #   Sprockets manifest
      #
      # @see https://github.com/sstephenson/sprockets/blob/master/lib/sprockets/manifest.rb
      #
      # @since 0.1.0
      # @api public
      def manifest
        @_manifest
      end

      ###
      # Returns a list of available asset compressors
      #
      # @return [Hash]
      #   List of available asset compressors
      #
      # @since 0.3.0
      # @api public
      def compressors
        @_compressors ||= Hash.new { |k, v| k[v] = Hash.new }
      end

      ###
      # Registers an asset compressor for use with Sprockets
      #
      # @param [Symbol] type
      #   The type of compressor you are registering (:js, :css)
      #
      # @example
      #   Padrino::Assets.register_compressor :js,  :simple => 'SimpleCompressor'
      #   Padrino::Assets.register_compressor :css, :simple => 'SimpleCompressor'
      #
      # @since 0.3.0
      # @api public
      def register_compressor(type, compressor)
        compressors[type].merge!(compressor)
      end

      # @since 0.3.0
      # @api private
      def find_registered_compressor(type, compressor)
        return compressor unless compressor.is_a?(Symbol)

        if compressor = compressors[type][compressor]
           compressor = compressor.safe_constantize
        end

        compressor.respond_to?(:new) ? compressor.new : compressor
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
        app.set :precompile_assets,  [ /^\w+\.(?!(?:js|css)$)/i, /^application\.(js|css)$/i ]

        # FIXME: Temporary fix for `padrino start`
        app.get '/assets/*' do
          env['PATH_INFO'].gsub!('/assets', '')
          Padrino::Assets.environment.call(env)
        end

        Padrino.after_load do
          require 'sprockets'

          environment = Sprockets::Environment.new(Padrino.root)

          environment.logger  = app.logger
          environment.version = app.assets_version

          if defined?(Padrino::Cache)
            if app.respond_to?(:caching) && app.caching?
              environment.cache = app.cache
            end
          end

          if app.compress_assets?
            environment.js_compressor  = find_registered_compressor(:js,  app.js_compressor)
            environment.css_compressor = find_registered_compressor(:css, app.css_compressor)
          end

          load_paths.flatten.each do |path|
            environment.append_path(path)
          end

          environment.context_class.class_eval do
            include Helpers
          end

          @_environment = app.index_assets ? environment.index : environment
          @_manifest    = Sprockets::Manifest.new(@_environment, app.manifest_file)
        end

        Padrino::Tasks.files << Dir[File.dirname(__FILE__) + '/tasks/**/*.rake']
      end
    end

    register_compressor :css, :yui      => 'YUI::CssCompressor'
    register_compressor :js,  :yui      => 'YUI::JavaScriptCompressor'
    register_compressor :js,  :closure  => 'Closure::Compiler'
    register_compressor :js,  :uglifier => 'Uglifier'
  end # Assets
end # Padrino