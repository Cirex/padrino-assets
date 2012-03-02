require_relative 'spec'

class TestCompressor;    end
class AnotherCompressor; end

describe Padrino::Assets do
  before do
    app.set :css_compressor, nil
    app.set :js_compressor,  nil
  end

  it 'can append paths to the Sprockets environment' do
    Padrino::Assets.load_paths << my_path = File.dirname(__FILE__) + '/fixtures/paths_test'

    Padrino.after_load.each(&:call)
    Padrino.clear!

    environment.paths.should include(my_path)
  end

  it 'can register a css compressor for use' do
    Padrino::Assets.register_compressor :css, :test => 'TestCompressor'
    Padrino::Assets.compressors[:css][:test].should == 'TestCompressor'
  end

  it 'can register a js compressor for use' do
    Padrino::Assets.register_compressor :js, :another => 'AnotherCompressor'
    Padrino::Assets.compressors[:js][:another].should == 'AnotherCompressor'
  end

  context '#find_registered_compressor' do
    before { Padrino::Assets.compressors.clear }

    it 'should allow you to manually locate a js compressor object' do
      Padrino::Assets.register_compressor :js, :test    => 'TestCompressor'
      Padrino::Assets.register_compressor :js, :another => 'AnotherCompressor'

      compressor = Padrino::Assets.find_registered_compressor(:js, :test)
      compressor.class.should == TestCompressor

      compressor = Padrino::Assets.find_registered_compressor(:js, :another)
      compressor.class.should == AnotherCompressor
    end

    it 'should allow you to manually locate a css compressor object' do
      Padrino::Assets.register_compressor :css, :test    => 'TestCompressor'
      Padrino::Assets.register_compressor :css, :another => 'AnotherCompressor'

      compressor = Padrino::Assets.find_registered_compressor(:css, :test)
      compressor.class.should == TestCompressor

      compressor = Padrino::Assets.find_registered_compressor(:css, :another)
      compressor.class.should == AnotherCompressor
    end

    it 'should return nil when no compressor object is found' do
      compressor = Padrino::Assets.find_registered_compressor(:css, :simple)
      compressor.should be_nil
    end
  end
end