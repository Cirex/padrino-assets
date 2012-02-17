PADRINO_ENV = 'test'

require 'rspec'
require 'rspec-html-matchers'
require 'padrino-assets'

module TestHelpers
  def app
    @app ||= Sinatra.new(Padrino::Application) do
      register Padrino::Assets
      set :manifest_file, File.join(settings.root, 'fixtures', 'compiled_assets', 'manifest.json')
      set :logging, false
    end
  end

  def settings
    app.settings
  end

  def request
    @request ||= Sinatra::Request.new(nil.to_s)
  end

  def environment
    Padrino::Assets.environment
  end

  def manifest
    Padrino::Assets.manifest
  end
end

RSpec.configure do |configuration|
  configuration.include TestHelpers
end

Padrino::Assets.load_paths << File.dirname(__FILE__) + '/fixtures/assets'