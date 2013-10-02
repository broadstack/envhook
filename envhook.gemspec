# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'envhook/version'

Gem::Specification.new do |spec|
  spec.name          = "envhook"
  spec.version       = Envhook::VERSION
  spec.authors       = ["Paul Annesley"]
  spec.email         = ["paul@annesley.cc"]
  spec.description   = %q{Webhook handler to update your .env}
  spec.summary       = %q{A Rack middleware which receives configuration, writes it to .env}
  spec.homepage      = "https://github.com/pda/envhook"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
