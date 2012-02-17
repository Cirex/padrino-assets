# Version History

### 0.3.0 - IN DEVELOPMENT
* Now uses [Sprockets](https://github.com/sstephenson/sprockets) `context_class` in-order to make helpers available to all assets

### 0.2.0 - (January 17, 2012)
* The current `request` is now passed to **:assets_host** when a `Proc` is used
* Added the rake task `assets:compress` for [deflating](http://en.wikipedia.org/wiki/Gzip) assets
* Basic support for asset minification

### 0.1.0 - (January 12, 2012)
* Initial release