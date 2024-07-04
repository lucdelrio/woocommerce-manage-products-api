# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'woocommerce/version'

Gem::Specification.new do |spec|
  spec.name          = "woocommerce"
  spec.version       = Woocommerce::VERSION
  spec.authors       = ["Josh Dvir"]
  spec.email         = ["shuky.dvir@gmail.com"]
  spec.summary       = %q{Ruby WooCommerce client library}
  spec.description   = %q{Ruby WooCommerce client library}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'httparty'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "awesome_print"
end
