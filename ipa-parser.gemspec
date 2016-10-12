# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ipa-parser/version'

Gem::Specification.new do |spec|
  spec.name          = "ipa-parser"
  spec.version       = IpaParser::VERSION
  spec.authors       = ["astro2linus"]
  spec.email         = ["astro2linus@gmail.com"]
  spec.summary       = %q{Extract information from a iPA file}
  spec.description   = %q{Extract information from a iPA file}
  spec.homepage      = "http://rubygems.org/gems/ipa-parser"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'CFPropertyList', '~> 2.3'
  spec.add_dependency 'rubyzip', '~> 1.1'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", '~> 0'
end
