require_relative 'spec'

describe Padrino::Assets do
  it 'can append paths to the Sprockets environment' do
    Padrino::Assets.load_paths << my_path = File.dirname(__FILE__) + '/fixtures/paths_test'

    Padrino.after_load.each(&:call)
    Padrino.clear!

    environment.paths.should include(my_path)
  end
end