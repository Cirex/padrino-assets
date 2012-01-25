# Padrino Assets

### Overview

Padrino assets is a plugin for the [Padrino](https://github.com/padrino/padrino-framework) web framework which makes use of the [Rack](https://github.com/rack/rack) plugin [Sprockets](https://github.com/sstephenson/sprockets) to manage and compile web assets.

### Setup & Installation

Include it in your project's `Gemfile` with Bundler:

``` ruby
gem 'padrino-assets'
```

Modify your `app/app.rb` file to register the plugin:

``` ruby
class ExampleApplication < Padrino::Application
  register Padrino::Assets
end
```

Modify your `config.ru` file to mount the environment:

``` ruby
map '/assets' do
  run Padrino::Assets.environment
end
```

By default, Sprockets is configured to load assets from your project's `app/assets` and `lib/assets` directories. Any files stored in these directories are readily available to the included helpers and will be served by the Sprockets middleware.

Because of this the following directories are no longer used and will instead be served statically:

* `public/images`
* `public/stylesheets`
* `public/javascripts`

You should now be storing your assets in the following directories:

* `app/assets/images`
* `app/assets/stylesheets`
* `app/assets/javascripts`

Should your project need to add additional paths you can do so by adding the following line:

``` ruby
Padrino::Assets.load_paths << 'path/to/my/assets'
```

### Dependencies

* [Padrino-Core](https://github.com/padrino/padrino-framework) and [Padrino-Helpers](https://github.com/padrino/padrino-framework)
* [Ruby](http://www.ruby-lang.org/en) >= 1.9.2
* [Sprockets](https://github.com/sstephenson/sprockets)

### TODO

* Additional documentation
* Tests

### Copyright

Copyright © 2012 Benjamin Bloch (Cirex). See LICENSE for details.