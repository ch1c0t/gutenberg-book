# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gutenberg/book/version'

Gem::Specification.new do |spec|
  spec.name          = "gutenberg-book"
  spec.version       = Gutenberg::Book::VERSION
  spec.authors       = ["Anatoly Chernow"]
  spec.email         = ["ch1c0t@yahoo.com"]
  spec.description   = %q{Parse books from Gutenberg Project}
  spec.summary       = %q{Parse books from Gutenberg Project}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'daybreak'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
