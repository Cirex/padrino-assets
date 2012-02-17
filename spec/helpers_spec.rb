require_relative 'spec'

describe Padrino::Assets::Helpers do
  include Padrino::Helpers::OutputHelpers
  include Padrino::Helpers::TagHelpers
  include Padrino::Assets::Helpers

  context '#assets_path' do
    before { Padrino.reload! }

    it 'should prepend :assets_host when present' do
      app.set :assets_host, 'http://www.test.com'
      asset = asset_path('application.css')
      asset.should == 'http://www.test.com/assets/application.css'
    end

    it 'should allow :assets_host to use a Proc' do
      app.set :assets_host, ->(asset, request) { 'http://test.com' }
      asset = asset_path('application.css')
      asset.should == 'http://test.com/assets/application.css'
    end

    it 'should pass the current source to :assets_host when a Proc is used' do
      app.set :assets_host, ->(asset, request) do
        if asset =~ /application.css/
          'http://true.com'
        else
          'http://false.com'
        end
      end
      asset = asset_path('application.css')
      asset.should == 'http://true.com/assets/application.css'
    end

    it 'should pass the current request to :assets_host when a Proc is used' do
      app.set :assets_host, ->(asset, request) do
        if request.ssl?
          'https://test.com'
        else
          'http://test.com'
        end
      end
      asset = asset_path('application.css')
      asset.should == 'http://test.com/assets/application.css'
    end

    it 'should append extension when provided' do
      asset = asset_path(:application, :css)
      asset.should == '/assets/application.css'
    end

    it 'should not append extension when one is present' do
      asset = asset_path('application.css', :css)
      asset.should_not == '/assets/application.css.css'
    end

    it 'should prepend :assets_prefix when present' do
      app.set :assets_prefix, '/test'
      asset = asset_path('application.css')
      asset.should == '/test/application.css'
    end

    it 'should prepend a forward slash to :assets_prefix when missing' do
      app.set :assets_prefix, 'test'
      asset = asset_path('application.css')
      asset.should == '/test/application.css'
    end

    it 'should not interfere with a reference URI' do
      asset = asset_path('/application.css')
      asset.should == '/application.css'

      asset = asset_path('//test.com/application.css')
      asset.should == '//test.com/application.css'
    end

    it 'should not interfere with an absolute URI' do
      asset = asset_path('http://test.com/application.css')
      asset.should == 'http://test.com/application.css'

      asset = asset_path('https://test.com/application.css')
      asset.should == 'https://test.com/application.css'
    end

    it 'should use precompiled asset when assets are indexed' do
      app.enable :index_assets
      asset = asset_path('application.css')
      asset.should == '/assets/application-b8588c6975a4539fbf2c11471870bdca.css'
    end

    it 'should allow assets that have not been precompiled when assets are index' do
      app.enable :index_assets
      asset = asset_path('application.js')
      asset.should == '/assets/application.js'
    end
  end

  context '#is_uri?' do
    it 'should return true when given an absolute URI' do
      is_uri?('https://example.com/application.css').should be_true
      is_uri?('http://example.com/application.css').should be_true
      is_uri?('ftp://example.com/application.css').should be_true
    end

    it 'should return true when given a reference URI' do
      is_uri?('//example.com/assets/application.css').should be_true
      is_uri?('/assets/application.css').should be_true
    end

    it 'should return false when given a host without a protocol' do
      is_uri?('example.com/assets/application.css').should be_false
    end

    it 'should return false when given an asset' do
      is_uri?('application.css').should be_false
    end
  end

  context '#stylesheet' do
    it 'should accept multiple sources' do
      stylesheets = stylesheets(:application, :theme)
      stylesheets.should have_tag(:link, count: 1, with: { href: '/assets/application.css' })
      stylesheets.should have_tag(:link, count: 1, with: { href: '/assets/theme.css' })
    end

    it 'should accept multiple sources with attributes' do
      stylesheets = stylesheets(:application, :theme, media: 'handheld')
      stylesheets.should have_tag(:link, count: 1, with: { href: '/assets/application.css', media: 'handheld' })
      stylesheets.should have_tag(:link, count: 1, with: { href: '/assets/theme.css', media: 'handheld' })
    end

    it 'should accept a single source' do
      stylesheet = stylesheet(:application)
      stylesheet.should have_tag(:link, count: 1, with: { href: '/assets/application.css' })
    end

    it 'should accept a single source with attributes' do
      stylesheet = stylesheet(:application, media: 'handheld')
      stylesheet.should have_tag(:link, count: 1, with: { href: '/assets/application.css', media: 'handheld' })
    end

    it 'should be aliased for compatibility' do
      respond_to?(:stylesheet_link_tag).should be_true
    end
  end

  context '#javascript' do
    it 'should accept multiple sources' do
      javascripts = javascripts(:application, :jquery)
      javascripts.should have_tag(:script, count: 1, with: { src: '/assets/application.js' })
      javascripts.should have_tag(:script, count: 1, with: { src: '/assets/jquery.js' })
    end

    it 'should accept a single source' do
      javascripts = javascript(:application)
      javascripts.should have_tag(:script, count: 1, with: { src: '/assets/application.js' })
    end

    it 'should be aliased for compatibility' do
      respond_to?(:javascript_include_tag).should be_true
    end
  end

  context '#image' do
    it 'should accept multiple sources' do
      images = images('application.jpg', 'application.png')
      images.should have_tag(:img, count: 1, with: { src: '/assets/application.jpg' })
      images.should have_tag(:img, count: 1, with: { src: '/assets/application.png' })
    end

    it 'should accept multiple sources with attributes' do
      images = images('application.jpg', 'application.png', width: 40, height: 40)
      images.should have_tag(:img, count: 1, with: { src: '/assets/application.jpg', width: 40, height: 40 })
      images.should have_tag(:img, count: 1, with: { src: '/assets/application.png', width: 40, height: 40 })
    end

    it 'should accept a single source' do
      image = image('application.jpg')
      image.should have_tag(:img, count: 1, with: { src: '/assets/application.jpg' })
    end

    it 'should accept a single source with attributes' do
      image = image('application.jpg', width: 40, height: 40)
      image.should have_tag(:img, count: 1, with: { src: '/assets/application.jpg', width: 40, height: 40 })
    end

    it 'should allow you to set the :width and :height with :size' do
      image = image('application.jpg', size: '40x40')
      image.should have_tag(:img, with: { width: 40, height: 40 })
    end

    it 'should allow you to use an array with :size' do
      image = image('application.jpg', size: [40, 40])
      image.should have_tag(:img, with: { width: 40, height: 40 })
    end

    it 'should automatically set an alternate text when none present' do
      images = images('application.jpg', 'test.jpg')
      images.should have_tag(:img, with: { alt: 'Application' })
      images.should have_tag(:img, with: { alt: 'Test' })
    end

    it 'should allow you to manually set the alternate text' do
      image = image('application.jpg', alt: 'My Little Pony')
      image.should have_tag(:img, with: { alt: 'My Little Pony' })
    end

    it 'should be aliased for compatibility' do
      respond_to?(:image_tag).should be_true
    end
  end

  context '#alternate_text' do
    it 'should capitalize the first letter' do
      alternate_text = alternate_text('application.jpg')
      alternate_text.should == 'Application'
    end

    it 'should seperate underscores' do
      alternate_text = alternate_text('my_pony.jpg')
      alternate_text.should == 'My pony'
    end
  end

  context '#video' do
    it 'should accept multiple sources' do
      videos = videos('test.webm', 'test.mov')
      videos.should have_tag(:video, count: 1) do
        with_tag(:source, count: 1, with: { src: '/assets/test.webm' })
        with_tag(:source, count: 1, with: { src: '/assets/test.mov' })
      end
    end

    it 'should accept multiple sources with attributes' do
      videos = videos('test.webm', 'test.mov', width: 40, height: 40)
      videos.should have_tag(:video, count: 1, with: { width: 40, height: 40 }) do
        with_tag(:source, count: 1, with: { src: '/assets/test.webm' })
        with_tag(:source, count: 1, with: { src: '/assets/test.mov' })
      end
    end

    it 'should accept a single source' do
      video = video('test.webm')
      video.should have_tag(:video, count: 1, with: { src: '/assets/test.webm' })
    end

    it 'should accept a single source with attributes' do
      video = video('test.webm', width: 40, height: 40)
      video.should have_tag(:video, count: 1, with: { src: '/assets/test.webm', width: 40, height: 40 })
    end

    it 'should allow you to set the :width and :height with :size' do
      video = video('test.webm', size: '40x40')
      video.should have_tag(:video, with: { width: 40, height: 40 })
    end

    it 'should allow you to use an array with :size' do
      video = video('test.webm', size: [40, 40])
      video.should have_tag(:video, with: { width: 40, height: 40 })
    end
  end

  context '#audio' do
    it 'should accept multiple sources' do
      audios = audios('test.ogg', 'test.aac')
      audios.should have_tag(:audio, count: 1) do
        with_tag(:source, count: 1, with: { src: '/assets/test.ogg' })
        with_tag(:source, count: 1, with: { src: '/assets/test.aac' })
      end
    end

    it 'should accept multiple sources with attributes' do
      audios = audios('test.ogg', 'test.aac', id: 'audio')
      audios.should have_tag(:audio, count: 1, with: { id: 'audio' }) do
        with_tag(:source, count: 1, with: { src: '/assets/test.ogg' })
        with_tag(:source, count: 1, with: { src: '/assets/test.aac' })
      end
    end

    it 'should accept a single source' do
      audio = audio('test.ogg')
      audio.should have_tag(:audio, count: 1, with: { src: '/assets/test.ogg' })
    end

    it 'should accept a single source with attributes' do
      audio = audio('test.ogg', id: 'audio')
      audio.should have_tag(:audio, count: 1, with: { src: '/assets/test.ogg', id: 'audio' })
    end
  end
end