# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yotsuba/version'

Gem::Specification.new do |spec|
  spec.name          = "yotsuba"
  spec.version       = Yotsuba::VERSION
  spec.authors       = ["Suchipi Izumi"]
  spec.email         = ["me@suchipi.com"]

  spec.summary       = %q{Yotsuba facilitates getting download links from the DomDomSoft Anime Downloader server.}
  spec.homepage      = "https://github.com/suchipi/yotsuba"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "pry"

  spec.add_dependency "savon", "~> 2.11"
  spec.add_dependency "concurrent-ruby", "~> 0.8"
  spec.add_dependency "typhoeus", "~> 0.7"
end
