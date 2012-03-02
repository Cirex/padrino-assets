require_relative 'spec'
require 'fileutils'
require 'tmpdir'
require 'rake'

describe 'Rake Tasks' do
  let :temp_directory do
   File.join(Dir.tmpdir, 'sprockets')
  end

  let(:image)      { File.join(temp_directory, environment['pony.jpg'].digest_path) }
  let(:stylesheet) { File.join(temp_directory, environment['application.css'].digest_path) }
  let(:javascript) { File.join(temp_directory, environment['application.js'].digest_path) }

  let :rake do
    Rake.application
  end

  before do
    app.set :manifest_file, File.join(temp_directory, 'manifest.json')
    app.set :app_obj, app

    Padrino.after_load.each(&:call)
    Padrino.clear!

    Padrino.insert_mounted_app(app)

    Rake.application = Rake::Application.new
    Dir.glob(File.expand_path('../../lib/tasks/*.rake', __FILE__)).each do |task|
      load(task)
    end
    rake.load_imports
  end

  after do
    FileUtils.rm_rf(temp_directory)
  end

  context 'assets:precompile' do
    it 'should allow you to use a regexp to filter assets' do
      app.set :precompile_assets, [/^application\.(css|js)$/]
      rake['assets:precompile'].invoke

      File.should     exist(stylesheet)
      File.should     exist(javascript)
      File.should_not exist(image)
    end

    it 'should allow you to use a proc to filter assets' do
      app.set :precompile_assets, [ ->(asset) { !File.extname(asset).in?(['.css', '.js']) } ]
      rake['assets:precompile'].invoke

      File.should     exist(image)
      File.should_not exist(stylesheet)
      File.should_not exist(javascript)
    end

    it 'should allow you to use a string to filter assets' do
      app.set :precompile_assets, ['pony.jpg', 'application.css']
      rake['assets:precompile'].invoke

      File.should     exist(stylesheet)
      File.should     exist(image)
      File.should_not exist(javascript)
    end

    it 'should automatically compress assets when enabled' do
      app.set :precompile_assets, ['application.css']
      app.set :compress_assets, true

      rake['assets:precompile'].invoke

      File.should exist(stylesheet)
      File.should exist(stylesheet + '.gz')
    end
  end

  context 'assets:clobber' do
    it 'should delete the directory' do
      rake['assets:precompile'].invoke
      File.should exist(app.manifest_file)

      rake['assets:clobber'].invoke
      File.should_not exist(manifest.dir)
    end
  end

  context 'assets:compress' do
    it 'should compress assets' do
      app.set :precompile_assets, [/^application\.(css|js)$/]
      app.set :compress_assets, false

      rake['assets:precompile'].invoke
      rake['assets:compress'].invoke

      File.should exist(stylesheet)
      File.should exist(stylesheet + '.gz')
      File.should exist(javascript)
      File.should exist(javascript + '.gz')
    end

    it 'should only compress text based assets' do
      app.set :precompile_assets, [/.+/]
      app.set :compress_assets, false

      rake['assets:precompile'].invoke
      rake['assets:compress'].invoke

      File.should     exist(stylesheet + '.gz')
      File.should     exist(javascript + '.gz')
      File.should_not exist(image + '.gz')
    end
  end
end