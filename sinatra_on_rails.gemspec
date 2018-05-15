# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatra_on_rails/version'

Gem::Specification.new do |spec|
  spec.name = 'sinatra-on-rails'
  spec.version = SinatraOnRails::VERSION
  spec.authors = ['Isay']
  spec.email = ['yasnet21@gmail.com']

  spec.summary = 'Sinatra with some Rails features.'
  spec.description = 'Sinatra with some Rails features.'
  spec.homepage = 'https://github.com/iszandro/sinatra_on_rails'
  spec.license = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'rake'
  spec.add_dependency 'sinatra', '~> 2.0.1'
  spec.add_dependency 'sinatra-contrib'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'rack-test'
end
