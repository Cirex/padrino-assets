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

   it 'should not interfere with a direct URI' do
     asset = asset_path('/application.css')
     asset.must_equal '/application.css'

     asset = asset_path('//test.com/application.css')
     asset.must_equal '//test.com/application.css'

     asset = asset_path('http://test.com/application.css')
     asset.must_equal 'http://test.com/application.css'
   end
  end
end