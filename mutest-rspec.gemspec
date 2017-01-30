require File.expand_path('../lib/mutest/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'mutest-rspec'
  gem.version     = Mutest::VERSION.dup
  gem.authors     = ['Daniel Gollahon', 'John Backus']
  gem.email       = ['johncbackus@gmail.com', 'daniel.gollahon@gmail.com']
  gem.description = 'Rspec integration for mutest'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/backus/mutest'
  gem.license     = 'MIT'

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files -- lib/mutest/integration/rspec.rb`.split("\n")
  gem.test_files       = `git ls-files -- spec/{integration,unit}/mutest/rspec_spec.rb}`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE]

  gem.add_runtime_dependency('mutest', "~> #{gem.version}")
  gem.add_runtime_dependency('rspec-core', '>= 3.4.0', '< 3.6.0')

  gem.add_development_dependency('bundler', '~> 1.3', '>= 1.3.5')
end
