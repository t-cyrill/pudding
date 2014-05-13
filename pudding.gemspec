# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pudding/version'

Gem::Specification.new do |spec|
  spec.name          = "pudding"
  spec.version       = Pudding::VERSION
  spec.authors       = ["cyrill"]
  spec.email         = ["siril.taka@gmail.com"]
  spec.summary       = %q{Image transformation server on demand.}
  spec.description   = %q{Pudding is image transformation server on demand. It was designed to help application development. It should not be used on a public network.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"

  spec.add_dependency "sinatra"
  spec.add_dependency "sinatra-contrib"
  spec.add_dependency "rmagick"
end
