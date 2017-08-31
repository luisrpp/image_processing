# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'image_processing/version'

Gem::Specification.new do |spec|
  spec.name          = 'image_processing'
  spec.version       = ImageProcessing::VERSION
  spec.authors       = ['Luis Roberto Pereira de Paula']
  spec.email         = ['luisrpp@gmail.com']

  spec.summary       = 'Image processing in Ruby'
  spec.description   = 'Image processing in Ruby'
  spec.homepage      = 'https://github.com/luisrpp/image_processing'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'ruby-vips', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'ruby-prof'
end
