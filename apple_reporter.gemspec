# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apple_reporter/version'

Gem::Specification.new do |spec|
  spec.name          = 'apple_reporter'
  spec.version       = AppleReporter::VERSION
  spec.authors       = ['Dean Lin']
  spec.email         = ['iscreen@gmail.com']

  spec.summary       = %q{Apple iTunes Connect Reporter}
  spec.description   = %q{Apple iTunes Connect Reporter}
  spec.homepage      = 'https://github.com/iscreen/apple_reporter.git'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = 'Set to "https://github.com/iscreen/apple_reporter.git"'
  # else
  #   raise 'RubyGems 2.0 or newer is required to protect against ' \
  #     'public gem pushes.'
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency('nokogiri')
  spec.add_dependency('activesupport')
  spec.add_dependency('rest-client')

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 2.3'
  spec.add_development_dependency 'activesupport', '~> 4.0'
end
