require 'sinatra'
require 'sinatra/config_file'
require 'rmagick'

module Pudding
  class App < Sinatra::Base
    before do
      @settings = YAML.load_file(settings.config_file)
    end

    configure do
      mime_type :jpg, 'image/jpeg'
      mime_type :png, 'image/png'
      mime_type :gif, 'image/gif'
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
      base = @settings['basedir']
      matcher = Regexp.compile(@settings['pudding_pattern']).match(params[:splat].first)
      path = matcher ? matcher[:path] : params[:splat].first
      image = Magick::Image.read(base + path).first

      if matcher
        case
          when matcher[:size]
            width, height = matcher[:size], matcher[:size]
          when matcher[:width] && matcher[:height]
            width, height = matcher[:width], matcher[:height]
        end
        image = image.resize_to_fill(width.to_i, height.to_i)
      end

      case image.format
        when 'GIF'; content_type :gif
        when 'PNG'; content_type :png
        when 'JPEG'; content_type :jpg
      end

      return image.to_blob
    end
  end
end
