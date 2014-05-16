# Pudding

Pudding is image transformation server on demand.

It was designed to help application development. It should not be used on a public network.

Pudding is inspired by [mod_small_light](http://code.google.com/p/smalllight/), [ngx_small_light](https://github.com/cubicdaiya/ngx_small_light), and Tofu (Cookpad's).

"Milk pudding" looks like "Tofu". :)

![kanten](https://raw.githubusercontent.com/t-cyrill/pudding/master/material/images/kanten.jpg)

(This is not pudding. It's kanten.)

## Requirement

* ImageMagick for rmagick
* Ruby > 2.0.0

## Installation

### ImageMagick

Install ImageMagick before pudding installation.

#### For OSX Users

```
brew install imagemagick
```

#### For Debian Users

```
apt-get install imagemagick
```

### Pudding Installation

Add this line to your application's Gemfile:

    gem 'pudding', :git => "https://github.com/t-cyrill/pudding"

And then execute:

    $ bundle

Or install it yourself.

## Usage

configration example: config/pudding.yml.sample

```
$ bundle exec pudding -c config/pudding.yml
```

And open http://localhost:4567/

### Change port

Use `-p` option.

```
$ bundle exec pudding -c config/pudding.yml -p 12345
```

## Contributing

1. Fork it ( http://github.com/t-cyrill/pudding/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
