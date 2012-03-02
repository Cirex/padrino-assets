# encoding: utf-8
module Padrino
  module Assets
    module Helpers
      URI_REGEXP = %r(^[a-z]+://|^/)
      ###
      # Returns an HTML stylesheet link tag for the specified sources
      #
      # @overload stylesheet(sources)
      #   @param [Array<String, Symbol>] sources
      #     Asset sources
      #
      # @overload stylesheet(sources, options)
      #   @param [Array<String, Symbol>] sources
      #     Asset sources
      #   @param [Hash] options
      #     The HTML options to include in this stylesheet
      #
      #   @option options [String] :media ('screen')
      #     Specifies the type of device the linked document is optimized for
      #
      # @return [String]
      #   Generated HTML for sources with specified options
      #
      # @example
      #   stylesheet(:application)
      #   # => <link href="/assets/application.css" media="screen" rel="stylesheet" type="text/css">
      #
      #   stylesheets(:application, :theme)
      #   # => <link href="/assets/application.css" media="screen" rel="stylesheet" type="text/css">
      #   # => <link href="/assets/theme.css" media="screen" rel="stylesheet" type="text/css">
      #
      #   stylesheet(:handheld, media: 'handheld')
      #   # => <link href="/assets/handheld.css" media="handheld" rel="stylesheet" type="text/css">
      #
      #   stylesheet('http://www.example.com/style.css')
      #   # => <link href="http://www.example.com/style.css" media="screen" rel="stylesheet" type="text/css">
      #
      # @since 0.1.0
      # @api public
      def stylesheet(*sources)
        options = sources.extract_options!.symbolize_keys
        options.reverse_merge!(media: 'screen', rel: 'stylesheet', type: 'text/css')
        sources.collect do |source|
          tag(:link, options.reverse_merge(href: asset_path(source, :css)))
        end.join("\n")
      end
      alias_method :stylesheets,         :stylesheet
      alias_method :include_stylesheet,  :stylesheet
      alias_method :include_stylesheets, :stylesheet
      alias_method :stylesheet_link_tag, :stylesheet

      ###
      # Returns an HTML script tag for the specified sources
      #
      # @overload javascript(sources)
      #   @param [Array<String, Symbol>] source
      #     Asset sources
      #
      # @overload javascript(sources, options)
      #   @param [Array<String, Symbol>] sources
      #     Asset sources
      #   @param [Hash] options
      #     The HTML options to include in this script tag
      #
      # @return [String]
      #   Generated HTML for sources with specified options
      #
      # @example
      #   javascript(:jquery)
      #   # => <script type="text/javascript" src="/assets/jquery.js"></script>
      #
      #   javascripts(:jquery, :application)
      #   # => <script type="text/javascript" src="/assets/jquery.js"></script>
      #   # => <script type="text/javascript" src="/assets/application.js"></script>
      #
      #   javascript('http://www.example.com/application.js')
      #   # => <script type="text/javascript" src="http://www.example.com/application.js"></script>
      #
      # @since 0.1.0
      # @api public
      def javascript(*sources)
        options = sources.extract_options!.symbolize_keys
        options.reverse_merge!(type: 'text/javascript')
        sources.collect do |source|
          content_tag(:script, nil, options.reverse_merge(src: asset_path(source, :js)))
        end.join("\n")
      end
      alias_method :javascripts,            :javascript
      alias_method :include_javascript,     :javascript
      alias_method :include_javascripts,    :javascript
      alias_method :javascript_include_tag, :javascript

      ###
      # Returns an HTML image element for the specified sources
      #
      # @overload image(sources)
      #   @param [Array<String>] sources
      #     Asset sources
      #
      # @overload image(sources, options)
      #   @param [Array<String>] sources
      #     Asset ources
      #   @param [Hash] options
      #     The HTML options to include in this image
      #
      #   @option options [String] :id
      #     Specifies a unique identifier for the image
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
      #   @option options [String] :title
      #     Specifies the title of the image
      #   @option options [Boolean] :draggable
      #     Specifies whether or not the image is draggable (true, false, :auto)
      #   @option options [Boolean] :hidden
      #     Should the image be hidden from view
      #
      # @return [String]
      #   Generated HTML for sources with specified options
      #
      # @example
      #   image('example.png')
      #   # => <img src="/assets/example.png" alt="Example">
      #
      #   image('example.png', size: '40x40')
      #   # => <img src="/assets/example.png" width="40" height="40" alt="Example">
      #
      #   image('example.png', size: [40, 40])
      #   # => <img src="/assets/example.png" width="40" height="40" alt="Example">
      #
      #   image('example.png', alt: 'My Little Pony')
      #   # => <img src="/assets/example.png" alt="My Little Pony">
      #
      #   image('http://www.example.com/example.png')
      #   # => <img src="http://www.example.com/example.png" alt="Example">
      #
      #   images('example.png', 'example.jpg')
      #   # => <img src="/assets/example.png" alt="Example">
      #   # => <img src="/assets/example.jpg" alt="Example">
      #
      #   image('example.jpg', data: { nsfw: true, geo: [34.087, -118.407] })
      #   # => <img src="example.jpg" data-nsfw="true" data-geo="34.087 -118.407">
      #
      # @since 0.1.0
      # @api public
      def image(*sources)
        options = sources.extract_options!.symbolize_keys

        if size = options.delete(:size)
          options[:width], options[:height] = size =~ /^\d+x\d+$/ ? size.split('x') : size
        end

        sources.collect do |source|
          alternate_text = options.fetch(:alt, alternate_text(source))
          tag(:img, options.reverse_merge(src: asset_path(source), alt: alternate_text))
        end.join("\n")
      end
      alias_method :images,    :image
      alias_method :image_tag, :image

      ###
      # Returns an alternate text based off the specified source
      #
      # @param [String] source
      #   Asset Source
      #
      # @return [String]
      #   Humanized alternate text
      #
      # @example
      #   alternate_text('padrino.jpg')
      #   # => 'Padrino'
      #
      #   alternate_text('my_pony.jpg')
      #   # => 'My pony'
      #
      # @since 0.3.0
      # @api semipublic
      def alternate_text(source)
        File.basename(source, '.*').humanize
      end

      ###
      # Returns an HTML video element for the specified sources
      #
      # @overload video(sources)
      #   @param [Array<String>] source
      #     Asset Sources
      #
      # @overload video(sources, options)
      #   @param [Array<String>] sources
      #     Asset Sources
      #   @param [Hash] options
      #     The HTML options to include in this video
      #
      #   @option options [String] :id
      #     Specifies a unique identifier for the video
      #   @option options [String] :class
      #     Specifies the class of the video
      #   @option options [String] :size
      #     Specifies the width and height of the video
      #   @option options [Integer] :width
      #     Specifies the width of the video
      #   @option options [Integer] :height
      #     Specifies the height of the video
      #   @option options [String] :title
      #     Specifies the title of the video
      #   @option options [Boolean] :draggable
      #     Specifies whether or not the video is draggable (true, false, :auto)
      #   @option options [Symbol] :preload
      #     Specifies the method the web browser should use to preload the video (:auto, :metadata, :none)
      #   @option options [String] :poster
      #     Specifies an image to be shown while the video is downloading, or until the user hits the play button
      #   @option options [Boolean] :hidden
      #     Should the video be hidden from view
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
      #   Generated HTML for sources with specified options
      #
      # @example
      #   video('example.webm')
      #   # => <video src="/assets/example.webm">
      #
      #   video('example.webm', loop: true, autoplay: true)
      #   # => <video src="/assets/example.webm" loop="loop" autoplay="autoplay">
      #
      #   video('example.webm', size: '40x40')
      #   # => <video src="/assets/example.webm" width="40" height="40">
      #
      #   video('example.webm', size: [40, 40])
      #   # => <video src="/assets/example.webm" width="40" height="40">
      #
      #   video('http://www.example.com/example.webm')
      #   # => <video src="http://www.example.com/example.webm">
      #
      #   videos('example.webm', 'example.mov')
      #   # => <video>
      #   # =>   <source src="/assets/example.webm">
      #   # =>   <source src="/assets/example.mov">
      #   # => </video>
      #
      #   video('example.webm', poster: 'preload.jpg')
      #   # => <video src="/assets/example.webm" poster="/assets/preload.jpg">
      #
      # @since 0.1.0
      # @api public
      def video(*sources)
        options = sources.extract_options!.symbolize_keys
        sources = sources.shift if sources.size == 1

        if options[:poster]
           options[:poster] = asset_path(options[:poster])
        end

        if size = options.delete(:size)
          options[:width], options[:height] = size =~ /^\d+x\d+$/ ? size.split('x') : size
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

      ###
      # Returns an HTML audio element for the specified sources
      #
      # @overload audio(sources)
      #   @param [Array<String>] sources
      #     Asset sources
      #
      # @overload audio(sources, options)
      #   @param [Array<String>] sources
      #     Asset sources
      #   @param [Hash] options
      #     The HTML options to include in this audio
      #
      #   @option options [String] :id
      #     Specifies a unique identifier for the audio
      #   @option options [String] :class
      #     Specifies the class of the audio
      #   @option options [Boolean] :draggable
      #     Specifies whether or not the audio is draggable (true, false, :auto)
      #   @option options [Symbol] :preload
      #     Specifies the method the web browser should use to preload the audio (:auto, :metadata, :none)
      #   @option options [Boolean] :hidden
      #     Should the audio be hidden from view
      #   @option options [Boolean] :controls
      #     Should the audio controls be shown if present
      #   @option options [Boolean] :autoplay
      #     Should the audio automatically play when it's ready
      #   @option options [Boolean] :loop
      #     Should the audio automatically loop when it's done
      #
      # @return [String]
      #   Generated HTML for sources with specified options
      #
      # @example
      #   audio('example.ogg')
      #   # => <audio src="/assets/example.ogg">
      #
      #   audio('example.ogg', loop: true, autoplay: true)
      #   # => <audio src="/assets/example.ogg" loop="loop" autoplay="autoplay">
      #
      #   audio('http://www.example.com/example.ogg')
      #   # => <audio src="http://www.example.com/example.ogg">
      #
      #   audios('example.ogg', 'example.mp4')
      #   # => <audio>
      #   # =>   <source src="/assets/example.ogg">
      #   # =>   <source src="/assets/example.mp4">
      #   # => </audio>
      #
      # @since 0.1.0
      # @api public
      def audio(*sources)
        options = sources.extract_options!.symbolize_keys
        sources = sources.shift if sources.size == 1

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

      ###
      # Returns whether or not the provided source is a valid URI
      #
      # @param [String] source
      #   URI source
      #
      # @return [Boolean]
      #   *true* if it is a valid, *false* otherwise
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
      #   is_uri?('example.css')
      #   # => false
      #
      # @since 0.1.0
      # @api public
      def is_uri?(source)
        !!(source =~ URI_REGEXP)
      end

      ###
      # Returns a modified asset source based on the current application settings
      #
      # @param [String] source
      #   Asset source
      # @param [Symbol] extension
      #   Asset file extension
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

      def rewrite_extension(source, extension)
        if extension && File.extname(source).empty?
          "#{source}.#{extension}"
        else
          source
        end
      end

      def rewrite_asset(source)
        if settings.index_assets && asset = Assets.manifest.assets[source]
          source = asset
        end
        source
      end

      def rewrite_asset_path(source)
        source = File.join(settings.assets_prefix, source)
        source = "/#{source}" unless source[0] == ?/
        source
      end

      def rewrite_asset_host(source)
        host = settings.assets_host rescue settings.assets_host(source, request)
        host ? host + source : source
      end
    end # Helpers
  end # Assets
end # Padrino