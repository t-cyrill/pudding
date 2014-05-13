require 'sinatra'
require 'sinatra/config_file'
require 'rmagick'

module Pudding
  class App < Sinatra::Base
    set :root, File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'app'))

    before do
      @settings = YAML.load_file(settings.config_file)
    end

    configure do
      mime_type :jpg, 'image/jpeg'
    end

    get '/' do
      basedir = @settings['basedir']
      <<"EOS"
<!DOCTYPE html>
<meta charset="utf-8">
<title>Pudding</title>
<h1>Pudding</h1>
<p>Pudding is image transformation server on demand.
<p>It was designed to help application development. <em>It should not be used on a public network.</em>

<h2>Configrations</h2>
<dl>
  <dt>basedir
    <dd>#{basedir}
</dl>
EOS
    end

    get "/*" do
      matcher = Regexp.compile(@settings['pudding_pattern']).match(params[:splat].first)

      raise "'#{params[:splat].first}' is not match '#{@settings['pudding_pattern']}'" unless matcher

      case
      when matcher[:size]
        width, height = matcher[:size], matcher[:size]
      when matcher[:width] && matcher[:height]
        width, height = matcher[:width], matcher[:height]
      end

      path = matcher[:path]

      base = @settings['basedir']
      original = Magick::Image.read(base + path).first
      image = original.resize_to_fill(width.to_i, height.to_i)

      content_type :jpg
      return image.to_blob
    end
  end
end
