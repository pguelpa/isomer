# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'isomer/version'

Gem::Specification.new do |spec|
  spec.name          = "isomer"
  spec.version       = Isomer::VERSION
  spec.authors       = ["Paul Guelpa"]
  spec.email         = ["paul.guelpa@gmail.com"]
  spec.description   = %q{A general configuration solution}
  spec.summary       = %q{Define your configuration once, and change the data source without having to re-write your application code.}
  spec.homepage      = "https://github.com/pguelpa/isomer"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 2.14"
end
