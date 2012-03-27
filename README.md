# Padrino Assets

Overview
--------

Padrino assets is a plugin for the [Padrino](https://github.com/padrino/padrino-framework) web framework which uses [Sprockets](https://github.com/sstephenson/sprockets) to manage and compile web assets.

Setup & Installation
--------------------

Include it in your project's `Gemfile`

``` ruby
gem 'padrino-assets'
```

Modify your `app/app.rb` file to register the plugin:

``` ruby
class ExampleApplication < Padrino::Application
  register Padrino::Assets
end
```
* __Note:__ Because `padrino-assets` overrides some existing helpers the above must be placed below `Padrino::Helpers`

Modify your `config.ru` file to mount the environment:

``` ruby
map '/assets' do
  run Padrino::Assets.environment
end
```

By default, Sprockets is configured to load assets from your project's `app/assets` and `lib/assets` directories. Any files stored in these directories are readily available to the included helpers, and will be served by the Sprockets middleware.

Because of this the following directories are no longer used, and will be served statically:

* public/images
* public/stylesheets
* public/javascripts

You should now be storing your assets in the following directories:

* app/assets/images
* app/assets/stylesheets
* app/assets/javascripts

Should your project need to add additional paths you can easily do so by adding the following line:

``` ruby
Sprockets.append_path('path/to/my/assets')
```

Configuration
-------------

Although the defaults are enough to get you started. There are several configuration options available to further customize this plugin to your project's personal needs. The following options can be changed at anytime with `set`, `enable`, or `disable`.

#### :assets_host
Is the URL to the external server currently hosting your assets. Generally, you only set this option if you want to host your assets on a separate server or service such as Amazon S3.

When a `Proc` is used, the current asset, and request will be passed to it as arguments:

``` ruby
set :assets_hosts, ->(asset, request) do
  if request.ssl?
    'https://secure.assets.com'
  else
    'http://assets.com'
  end
end
```

Of course if you don't need anything flashy a string will suffice:

``` ruby
set :assets_host, 'http://assets.com'
```

#### :compress_assets
If enabled, will automatically compress, and gzip your assets to save server bandwidth.
Due to the Java dependencies, and the lack of a suitable pure Ruby alternative, a default compressor is not __currently__ provided.

#### :precompile_assets
Is an array of assets that will be compiled when the task `assets:precompile` is run.
Once compiled, an MD5 checksum is calculated and inserted into the file name.
This checksum serves as a way to version your assets so that they can be properly cached by web browsers.

To filter which assets are compiled you have a few options. As an example, using a regular expression:

``` ruby
set :precompile_assets, [/^\w\.(?!(?:css|js)$)/i]
```

The above would compile all assets that do not have the extension `.css` or `.js`.

Or if you prefer, a collection of files would work too:

``` ruby
set :precompile_assets, [
  'jquery.js',
  'jquery.unobtrusive.js',
  'application.css',
  'pony.jpg'
]
```

If you are deploying to a production environment it is recommended that you precompile your assets so that they can be statically served by your web server. In a development environment, your assets will be compiled with every request.

Dependencies
------------

* [Padrino-Core](https://github.com/padrino/padrino-framework)
* [Padrino-Helpers](https://github.com/padrino/padrino-framework)
* [Ruby](http://www.ruby-lang.org/en) >= 1.9.2
* [Sprockets](https://github.com/sstephenson/sprockets)

TODO
----

* Additional documentation

Copyright
---------

Copyright &copy; 2012 Benjamin Bloch (Cirex). See LICENSE for details.