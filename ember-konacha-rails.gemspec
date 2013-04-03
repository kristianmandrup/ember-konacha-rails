# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ember/konacha/rails/version'

Gem::Specification.new do |spec|
  spec.name          = "ember-konacha-rails"
  spec.version       = Ember::Konacha::Rails::VERSION
  spec.authors       = ["Kristian Mandrup"]
  spec.email         = ["kmandrup@gmail.com"]
  spec.description   = %q{Generate Konacha spec infrastructure for your Ember-Rails apps}
  spec.summary       = %q{Generate Konacha infrastructure for Ember}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 3.1"
  spec.add_dependency "httparty", ">= 0.9"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
