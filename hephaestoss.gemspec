# Encoding: UTF-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hephaestoss/version'

Gem::Specification.new do |spec|
  spec.name          = 'hephaestoss'
  spec.version       = Hephaestoss::VERSION
  spec.authors       = ['Jonathan Hartman']
  spec.email         = %w(jonathan.hartman@socrata.com)

  spec.summary       = 'A TOML-driven CloudFormation stack management tool'
  spec.description   = 'A TOML-driven CloudFormation stack management tool'
  spec.homepage      = 'https://github.com/socrata-platform/hephaestoss'
  spec.license       = 'Apache 2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w(lib)

  spec.required_ruby_version = '>= 2.0'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.34'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.10'
  spec.add_development_dependency 'simplecov-console', '~> 0.2'
  spec.add_development_dependency 'coveralls', '~> 0.8'
end
