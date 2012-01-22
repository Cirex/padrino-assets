module Padrino
  module Assets
    module Helpers
      ##
      # Returns an HTML stylesheet link tag for the specified sources
      #
      # @overload include_stylesheet(sources, options = {})
      #   @param [Array<String, Symbol>] sources
      #     Sources
      #   @param [Hash] options
      #     HTML options
      #   @option options [String] :media ('screen')
      #     Specifies the type of device the linked document is optimized for
      #
      # @return [String]
      #   Stylesheet link tag for +sources+ with specified +options+.
      #
      # @example
      #   include_stylesheets :application, :theme
      #   # => <link href="/assets/application.css" media="screen" rel="stylesheet" type="text/css">
      #   # => <link href="/assets/theme.css" media="screen" rel="stylesheet" type="text/css">
      #
      #   include_stylesheet :handheld, media: 'handheld'
      #   # => <link href="/assets/handheld.css" media="handheld" rel="stylesheet" type="text/css">
      #
      #   include_stylesheet 'http://www.example.com/style.css'
      #   # => <link href="http://www.example.com/style.css" media="screen" rel="stylesheet" type="text/css">
      #
      # @since 0.1.0
      # @api public
      def include_stylesheet(*sources)
        options = sources.extract_options!.symbolize_keys
        options.reverse_merge!(media: 'screen', rel: 'stylesheet', type: 'text/css')
        sources.collect do |source|
          tag(:link, options.reverse_merge(href: asset_path(source, :css)))
        end.join("\n")
      end
      alias_method :include_stylesheets, :include_stylesheet
      alias_method :stylesheet_link_tag, :include_stylesheet

      ##
      # Returns an HTML script tag for the specified sources
      #
      # @overload include_javascript(sources, options={})
      #   @param [Array<String, Symbol>] sources
      #     Sources
      #   @param [Hash] options
      #     HTML options
      #
      # @return [String]
      #   Script tag for +sources+ with specified +options+.
      #
      # @example
      #   include_javascripts :application, :jquery
      #   # => <script type="text/javascript" src="/assets/application.js"></script>
      #   # => <script type="text/javascript" src="/assets/jquery.js"></script>
      #
      #   include_javascript 'http://www.example.com/application.js'
      #   # => <script type="text/javascript" src="http://www.example.com/application.js"></script>
      #
      # @since 0.1.0
      # @api public
      def include_javascript(*sources)
        options = sources.extract_options!.symbolize_keys
        options.reverse_merge!(type: 'text/javascript')
        sources.collect do |source|
          content_tag(:script, nil, options.reverse_merge(src: asset_path(source, :js)))
        end.join("\n")
      end
      alias_method :include_javascripts,    :include_javascript
      alias_method :javascript_include_tag, :include_javascript

      ##
      # Returns an HTML image element with given sources and options
      #
      # @overload image(sources, options={})
      #   @param [Array<String>] sources
      #     Sources
      #   @param [Hash] options
      #     HTML options
      #   @option options [String] :id
      #     Specifies the identifier of the image
      #   @option options [String] :class
      #     Specifies the class of the image
      #   @option options [String] :size
      #     Specifies the width and height of the image
      #   @option options [Integer] :width
      #     Specifies the width of the image
      #   @option options [Integer] :height
      #     Specifies the height of the image
      #   @option options [String] :alt
      #     Specifies an alternate text for an image
      #
      # @return [String]
      #   Image tag with +url+ and specified +options+.
      #
      # @example
      #   image 'example.png'
      #   # => <img src="/assets/example.png" alt="Example" />
      #
      #   image 'example.png', size: '40x40'
      #   # => <img src="/assets/example.png" width="40" height="40" alt="Example" />
      #
      #   image 'example.png', width: 40
      #   # => <img src="/assets/example.png" width="40" alt="Example" />
      #
      #   image 'example.png', height: 40
      #   # => <img src="/assets/example.png" height="40" alt="Example" />
      #
      #   image 'example.png', alt: 'My Little Pony'
      #   # => <img src="/assets/example.png" alt="My Little Pony" />
      #
      #   image 'http://www.example.com/example.png'
      #   # => <img src="http://www.example.com/example.png" />
      #
      #   images 'example.png', 'example.jpg'
      #   # => <img src="/assets/example.png" alt="Example" />
      #   # => <img src="/assets/example.jpg" alt="Example" />
      #
      # @since 0.1.0
      # @api public
      def image(*sources)
        options = sources.extract_options!.symbolize_keys

        if size = options.delete(:size)
          options[:width], options[:height] = size.split('x') if size =~ /^[0-9]+x[0-9]+$/
        end

        sources.collect do |source|
          tag(:img, options.reverse_merge(src: asset_path(source)))
        end.join("\n")
      end
      alias_method :images,    :image
      alias_method :image_tag, :image

      ##
      # Return an HTML video element with given sources and options
      #
      # @overload video(sources, options={})
      #   @param [Array<String>] sources
      #     Sources
      #   @param [Hash] options
      #     HTML options
      #   @option options [String] :id
      #     Specifies the identifier of the video
      #   @option options [String] :class
      #     Specifies the class of the video
      #   @option options [String] :size
      #     Specifies the width and height of the video
      #   @option options [Integer] :width
      #     Specifies the width of the video
      #   @option options [Integer] :height
      #     Specifies the height of the video
      #   @option options [String] :preload
      #     Specifies the method the web browser should use to preload the video
      #   @option options [String] :poster
      #     Specifies an image to be shown while the video is downloading, or until the user hits the play button
      #   @option options [Boolean] :controls
      #     Should the video controls be shown if present
      #   @option options [Boolean] :muted
      #     Should the video automatically start off muted
      #   @option options [Boolean] :autoplay
      #     Should the video automatically play when it's ready
      #   @option options [Boolean] :loop
      #     Should the video automatically loop when it's done
      #
      # @return [String]
      #   Video tag with +url+ and specified +options+
      #
      # @example
      #   video 'example.webm'
      #   # => <video src="/assets/example.webm" />
      #
      #   video 'example.webm', controls: true, autoplay: true
      #   # => <video src="/assets/example.webm" controls="controls" autoplay="autoplay" />
      #
      #   video 'example.webm', loop: true
      #   # => <video src="/assets/example.webm" loop="loop" />
      #
      #   video 'example.webm', size: '40x40'
      #   # => <video src="/assets/example.webm" width="40" height="40" />
      #
      #   video 'example.webm', height: 40
      #   # => <video src="/assets/example.webm" height="40" />
      #
      #   video 'example.webm', width: 40
      #   # => <video src="/assets/example.webm" width="40" />
      #
      #   video 'http://www.example.com/example.webm'
      #   # => <video src="http://www.example.com/example.webm" />
      #
      #   videos 'example.webm', 'example.mov'
      #   # => <video>
      #   # =>   <source src="/assets/example.webm" />
      #   # =>   <source src="/assets/example.mov" />
      #   # => </video>
      #
      # @since 0.1.0
      # @api public
      def video(*sources)
        options = sources.extract_options!.symbolize_keys
        sources = sources.first if sources.size == 1

        if options[:poster]
           options[:poster] = asset_path(options[:poster])
        end

        if size = options.delete(:size)
          options[:width], options[:height] = size.split('x') if size =~ /^[0-9]+x[0-9]+$/
        end

        if sources.is_a?(Array)
          content_tag(:video, options) do
            sources.collect { |source| tag(:source, src: asset_path(source)) }.join("\n")
          end
        else
          tag(:video, options.reverse_merge(src: asset_path(sources)))
        end
      end
      alias_method :videos,    :video
      alias_method :video_tag, :video

      ##
      # Returns an HTML audio element with given sources and options
      #
      # @overload audio(sources, options={})
      #   @param [Array<String>] sources
      #     Sources
      #   @param [Hash] options
      #     HTML options
      #   @option options [String] :id
      #     Specifies the identifier of the audio
      #   @option options [String] :class
      #     Specifies the class of the audio
      #   @option options [String] :preload
      #     Specifies the method the web browser should use to preload the audio 
      #   @option options [Boolean] :controls
      #     Should the audio controls be shown if present
      #   @option options [Boolean] :autoplay
      #     Should the audio automatically play when it's ready
      #   @option options [Boolean] :loop
      #     Should the audio automatically loop when it's done
      #
      # @return [String]
      #   Audio tag with +url+ and specified +options+
      #
      # @example
      #   audio 'example.ogg'
      #   # => <audio src="/assets/example.ogg" />
      #
      #   audio 'example.ogg', controls: true, autoplay: true
      #   # => <audio src="/assets/example.ogg" controls="controls" autoplay="autoplay" />
      #
      #   audio 'example.ogg', loop: true
      #   # => <audio src="/assets/example.ogg" loop="loop" />
      #
      #   audio 'http://www.example.com/example.ogg'
      #   # => <audio src="http://www.example.com/example.ogg" />
      #
      #   audios 'example.ogg', 'example.mp4'
      #   # => <audio>
      #   # =>   <source src="/assets/example.ogg" />
      #   # =>   <source src="/assets/example.mp4" />
      #   # => </audio>
      #
      # @since 0.1.0
      # @api public
      def audio(*sources)
        options = sources.extract_options!.symbolize_keys
        sources = sources.first if sources.size == 1

        if sources.is_a?(Array)
          content_tag(:audio, options) do
            sources.collect { |source| tag(:source, src: asset_path(source)) }.join("\n")
          end
        else
          tag(:audio, options.reverse_merge(src: asset_path(sources)))
        end
      end
      alias_method :audios,    :audio
      alias_method :audio_tag, :audio

      ##
      # Determines whether or not the provided source is a valid URI
      #
      # @param [String] source
      #   URI Source
      #
      # @return [Boolean]
      #
      # @example
      #   is_uri?('http://www.example.com')
      #   # => true
      #
      #   is_uri?('www.example.com')
      #   # => false
      #
      #   is_uri?('//example.com')
      #   # => true
      #
      #   is_uri?('/example/example.css')
      #   # => true
      #
      # @since 0.1.0
      # @api public
      def is_uri?(source)
        !!(source =~ URI_REGEXP)
      end

      URI_REGEXP = %r[^[a-z]+://|^//?]

      ##
      # Returns a modified asset source based on the current application settings
      #
      # @overload asset_path(source, extension = nil)
      #   @param [String] source
      #     Source
      #   @param [Symbol] extension (nil)
      #     File extension
      #
      # @return [String]
      #   Modified source based on application settings
      #
      # @example
      #   asset_path('example.webm')
      #   # => '/assets/example.webm'
      #
      #   asset_path('stylesheet', :css)
      #   # => '/assets/stylesheet.css'
      #
      #   asset_path('http://www.example.com/stylesheet.css')
      #   # => 'http://www.example.com/stylesheet.css'
      #
      # @since 0.1.0
      # @api public
      def asset_path(source, extension = nil)
        return source if is_uri?(source)
        source = source.to_s
        source = rewrite_extension(source, extension)
        source = rewrite_asset(source)
        source = rewrite_asset_path(source)
        source = rewrite_asset_host(source)
        source
      end

    private

      # @private
      def rewrite_extension(source, extension)
        if extension && File.extname(source).empty?
          "#{source}.#{extension}"
        else
          source
        end
      end

      # @private
      def rewrite_asset(source)
        if settings.index_assets? && asset = Assets.manifest.assets[source]
          source = asset
        end
        source
      end

      # @private
      def rewrite_asset_path(source)
        source = File.join(settings.assets_prefix, source)
        source = "/#{source}" unless source[0] == ?/
        source
      end

      # @private
      def rewrite_asset_host(source)
        host = settings.assets_host rescue settings.assets_host(source, request)
        host ? host + source : source
      end
    end
  end
end