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

      enable :logging
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
      mode, matcher, rewrite_rule = :default, nil, nil
      req_path = params[:splat].first

      parsed = @settings['definitions'].each do |k, df|
        if reg = Regexp.compile(df['pattern']).match(req_path)
          break [k, df['rewrite'], reg]
        end
      end
      mode, rewrite_rule, matcher = parsed unless parsed == @settings['definitions']

      path = mode == :default ? req_path : matcher[:path]
      if rewrite_rule
        orig_path = path
        path = path.gsub(Regexp.compile(rewrite_rule[0]), rewrite_rule[1])
        env['rack.logger'].info "path rewrote #{orig_path} to #{path}" unless orig_path == path
      end
      image = Magick::Image.read(base + path).first

      unless mode == :default
        width, height = case
          when matcher[:size]
            [matcher[:size], matcher[:size]]
          when matcher[:width] && matcher[:height]
            [matcher[:width], matcher[:height]]
        end

        image = case mode
          when "fill"; image.resize_to_fill(width.to_i, height.to_i)
          when "fit"; image.resize_to_fit(width.to_i, height.to_i)
          else; image
        end
      end

      case image.format
        when 'GIF'; content_type :gif
        when 'PNG'; content_type :png
        when 'JPEG'; content_type :jpg
      end

      image.to_blob
    end
  end
end
