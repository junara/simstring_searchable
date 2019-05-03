# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simstring_searchable/version'

Gem::Specification.new do |spec|
  spec.name          = 'simstring_searchable'
  spec.version       = SimstringSearchable::VERSION
  spec.authors       = ['junara']
  spec.email         = ['jun5araki@gmail.com']

  spec.summary       = 'Search with simstring for ActiveRecord'
  spec.homepage      = 'https://github.com/junara/simstring_searchable'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'simstring_pure', '~>1.0'
end
