require 'webrat'
require 'padrino-assets'
require 'minitest/pride'
require 'minitest/autorun'

Padrino::Assets.load_paths << File.dirname(__FILE__) + '/fixtures/assets/**'

module MiniTest
  class Spec
    class << self
      alias_method :context, :describe
    end

    def app
      @app ||= Sinatra.new(Padrino::Application) do
        register Padrino::Assets
        set :environment, :test
      end
    end

    def settings
      app.settings
    end

    def request
      nil
    end
  end

  module Assertions
    include Webrat::Matchers

    def assert_has_tag(tag, html, attributes)
      selector = HaveSelector.new(tag, attributes)
      assert selector.matches?(html), selector.failure_message
    end

    def refute_has_tag(tag, html, attributes)
      selector = HaveSelector.new(tag, attributes)
      refute selector.matches?(html), selector.failure_message
    end
  end

  module Expectations
    infect_an_assertion :assert_has_tag, :must_have_tag
    infect_an_assertion :refute_has_tag, :wont_have_tag
  end
end

class Object
  include MiniTest::Expectations
end