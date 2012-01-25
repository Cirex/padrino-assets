require_relative 'test'

describe 'Helpers' do
  include Padrino::Helpers::OutputHelpers
  include Padrino::Helpers::TagHelpers
  include Padrino::Assets::Helpers

  describe 'assets_path' do
    it 'should prepend :assets_host when present' do
      app.set :assets_host, 'http://www.test.com'
      asset = asset_path('application.css')
      asset.must_equal 'http://www.test.com/assets/application.css'
    end

    it 'should allow :assets_host to use a Proc' do
      app.set :assets_host, ->(asset, request) { 'http://test.com' }
      asset = asset_path('application.css')
      asset.must_equal 'http://test.com/assets/application.css'
    end

    it 'should pass the current source to :assets_host when a Proc is used' do
      app.set :assets_host, ->(source, request) do
        if source =~ /application.css/
          'http://true.com'
        else
          'http://false.com'
        end
      end
      asset = asset_path('application.css')
      asset.must_equal 'http://true.com/assets/application.css'
    end

    it 'should append extension when provided' do
      asset = asset_path(:application, :css)
      asset.must_equal '/assets/application.css'
    end

    it 'should not append extension when one is present' do
      asset = asset_path('application.css', :css)
      asset.wont_equal '/assets/application.css.css'
    end

    it 'should prepend :assets_prefix when present' do
      app.set :assets_prefix, '/test'
      asset = asset_path('application.css')
      asset.must_equal '/test/application.css'
    end

    it 'should prepend a forward slash to :assets_prefix when missing' do
      app.set :assets_prefix, 'test'
      asset = asset_path('application.css')
      asset.must_equal '/test/application.css'
    end

    it 'should not interfere with a reference URI' do
      asset = asset_path('/application.css')
      asset.must_equal '/application.css'

      asset = asset_path('//test.com/application.css')
      asset.must_equal '//test.com/application.css'

      asset = asset_path('http://test.com/application.css')
      asset.must_equal 'http://test.com/application.css'
    end
  end

  describe 'is_uri?' do
    it 'should return true when given an absolute URI' do
      is_uri?('https://example.com/application.css').must_equal true
      is_uri?('http://example.com/application.css').must_equal true
      is_uri?('ftp://example.com/application.css').must_equal true
    end

    it 'should return true when given a reference URI' do
      is_uri?('//example.com/assets/application.css').must_equal true
      is_uri?('/assets/application.css').must_equal true
    end

    it 'should return false when given a host without a protocol' do
      is_uri?('example.com/assets/application.css').must_equal false
    end

    it 'should return false when given an asset' do
      is_uri?('application.css').must_equal false
    end
  end

  describe 'include_stylesheet' do
    it 'should accept multiple sources' do
      stylesheets = include_stylesheets :application, :theme
      stylesheets.must_have_tag :link, href: '/assets/application.css'
      stylesheets.must_have_tag :link, href: '/assets/theme.css'
    end

    it 'should accept multiple sources with attributes' do
      stylesheets = include_stylesheets :application, :theme, media: 'handheld'
      stylesheets.must_have_tag :link, href: '/assets/application.css', media: 'handheld'
      stylesheets.must_have_tag :link, href: '/assets/theme.css', media: 'handheld'
    end

    it 'should accept a single source' do
      stylesheet = include_stylesheet :application
      stylesheet.must_have_tag :link, href: '/assets/application.css'
    end

    it 'should accept a single source with attributes' do
      stylesheet = include_stylesheet :application, media: 'handheld'
      stylesheet.must_have_tag :link, href: '/assets/application.css', media: 'handheld'
    end

    it 'should allow a source with an extension' do
      stylesheet = include_stylesheet 'application.css'
      stylesheet.wont_have_tag :link, hreg: '/assets/application.css.css'
    end

    it 'should be aliased for compatibility' do
      respond_to?(:stylesheet_link_tag).must_equal true
    end
  end

  describe 'include_javascript' do
    it 'should accept multiple sources' do
      javascripts = include_javascripts :application, :jquery
      javascripts.must_have_tag :script, src: '/assets/application.js'
      javascripts.must_have_tag :script, src: '/assets/jquery.js'
    end

    it 'should accept a single source' do
      javascripts = include_javascript :application
      javascripts.must_have_tag :script, src: '/assets/application.js'
    end

    it 'should be aliased for compatibility' do
      respond_to?(:javascript_include_tag).must_equal true
    end
  end

  describe 'image' do
    it 'should accept multiple sources' do
      images = images 'application.jpg', 'application.png'
      images.must_have_tag :img, src: '/assets/application.jpg'
      images.must_have_tag :img, src: '/assets/application.png'
    end

    it 'should accept multiple sources with attributes' do
      images = images 'application.jpg', 'application.png', width: '40', height: '40'
      images.must_have_tag :img, src: '/assets/application.jpg', width: '40', height: '40'
      images.must_have_tag :img, src: '/assets/application.png', width: '40', height: '40'
    end

    it 'should accept a single source' do
      image = image 'application.jpg'
      image.must_have_tag :img, src: '/assets/application.jpg'
    end

    it 'should accept a single source with attributes' do
      image = image 'application.jpg', width: '40', height: '40'
      image.must_have_tag :img, width: '40', height: '40'
    end

    it 'should allow you to set the :width and :height with size' do
      image = image 'application.jpg', size: '40x40'
      image.must_have_tag :img, width: '40', height: '40'
    end

    it 'should allow you to set the :width' do
      image = image 'application.jpg', width: '40'
      image.must_have_tag :img, width: '40'
    end

    it 'should allow you to set the :height' do
      image = image 'application.jpg', height: '40'
      image.must_have_tag :img, height: '40'
    end

    it 'should allow you to set the alternate text' do
      image = image 'application.jpg', alt: 'My Little Pony'
      image.must_have_tag :img, alt: 'My Little Pony'
    end

    it 'should automatically set an alternate text when none present' do
      image = image 'application.jpg'
      image.must_have_tag :img, alt: 'Application'
    end

    it 'should allow you to set the :class' do
      image = image 'application.jpg', class: 'image'
      image.must_have_tag :img, class: 'image'
    end

    it 'should allow you to set the :id' do
      image = image 'application.jpg', id: 'logo'
      image.must_have_tag :img, id: 'logo'
    end

    it 'should be aliased for compatibility' do
      respond_to?(:image_tag).must_equal true
    end
  end

  describe 'video' do
    it 'should accept multiple sources' do
      videos = videos 'test.webm', 'test.mov'
      videos.must_have_tag :source, src: '/assets/test.webm'
      videos.must_have_tag :source, src: '/assets/test.mov'
    end

    it 'should accept multiple sources with attributes' do
      videos = videos 'test.webm', 'test.mov', width: '40', height: '40'
      videos.must_have_tag :video, width: '40', height: '40'
      videos.must_have_tag :source, src: '/assets/test.webm'
      videos.must_have_tag :source, src: '/assets/test.mov'
    end

    it 'should accept a single source' do
      video = video 'test.webm'
      video.must_have_tag :video, src: '/assets/test.webm'
    end

    it 'should accept a single source with attributes' do
      video = video 'test.webm', width: '40', height: '40'
      video.must_have_tag :video, src: '/assets/test.webm', width: '40', height: '40'
    end

    it 'should allow you to set the :class' do
      video = video 'test.webm', class: 'video'
      video.must_have_tag :video, class: 'video'
    end

    it 'should allow you to set the :id' do
      video = video 'test.webm', id: 'video'
      video.must_have_tag :video, id: 'video'
    end

    it 'should allow you to set the :width and :height with :size' do
      video = video 'test.webm', size: '40x40'
      video.must_have_tag :video, width: '40', height: '40'
    end

    it 'should allow you to set the :width' do
      video = video 'test.webm', width: '40'
      video.must_have_tag :video, width: '40'
    end

    it 'should allow you to set the :height' do
      video = video 'test.webm', height: '40'
      video.must_have_tag :video, height: '40'
    end

    it 'should allow :poster to use an absolute URI' do
      video = video 'test.webm', poster: 'http://test.com/poster.jpg'
      video.must_have_tag :video, poster: 'http://test.com/poster.jpg'
    end

    it 'should use asset_path when :poster is present' do
      video = video 'test.webm', poster: 'poster.jpg'
      video.must_have_tag :video, poster: '/assets/poster.jpg'
    end

    it 'should allow you to set the :preload method' do
      video = video 'test.webm', preload: 'auto'
      video.must_have_tag :video, preload: 'auto'
    end

    it 'should allow you to set :muted to true' do
      video = video 'test.webm', muted: true
      video.must_have_tag :video, muted: 'muted'
    end

    it 'should allow you to set :autoplay to true' do
      video = video 'test.webm', autoplay: true
      video.must_have_tag :video, autoplay: 'autoplay'
    end

    it 'should allow you to set :loop to true' do
      video = video 'test.webm', loop: true
      video.must_have_tag :video, loop: 'loop'
    end

    it 'should allow you to set :controls to true' do
      video = video 'test.webm', controls: true
      video.must_have_tag :video, controls: 'controls'
    end

    it 'should be aliased for compatibility' do
      respond_to?(:video_tag).must_equal true
    end
  end

  describe 'audio' do
    it 'should accept multiple sources' do
      audios = audios 'test.ogg', 'test.aac'
      audios.must_have_tag :source, src: '/assets/test.ogg'
      audios.must_have_tag :source, src: '/assets/test.aac'
    end

    it 'should accept multiple sources with attributes' do
      audios = audios 'test.ogg', 'test.aac', id: 'audio'
      audios.must_have_tag :audio, id: 'audio'
      audios.must_have_tag :source, src: '/assets/test.ogg'
      audios.must_have_tag :source, src: '/assets/test.aac'
    end

    it 'should accept a single source' do
      audio = audio 'test.ogg'
      audio.must_have_tag :audio, src: '/assets/test.ogg'
    end

    it 'should accept a single source with attributes' do
      audio = audio 'test.ogg', id: 'audio'
      audio.must_have_tag :audio, src: '/assets/test.ogg', id: 'audio'
    end

    it 'should allow you to set the :class' do
      audio = audio 'test.ogg', class: 'audio'
      audio.must_have_tag :audio, class: 'audio'
    end

    it 'should allow you to set the :id' do
      audio = audio 'test.ogg', id: 'audio'
      audio.must_have_tag :audio, id: 'audio'
    end

    it 'should allow you to set :autoplay to true' do
      audio = audio 'test.ogg', autoplay: true
      audio.must_have_tag :audio, autoplay: 'autoplay'
    end

    it 'should allow you to set :loop to true' do
      audio = audio 'test.ogg', loop: true
      audio.must_have_tag :audio, loop: 'loop'
    end

    it 'should allow you to set :controls to true' do
      audio = audio 'test.ogg', controls: true
      audio.must_have_tag :audio, controls: 'controls'
    end
  end
end