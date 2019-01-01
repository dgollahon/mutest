# frozen_string_literal: true

require File.expand_path('lib/mutest/version', __dir__)

Gem::Specification.new do |gem|
  gem.name        = 'mutest-minitest'
  gem.version     = Mutest::VERSION.dup
  gem.authors     = ['Daniel Gollahon', 'John Backus']
  gem.email       = ['johncbackus@gmail.com', 'daniel.gollahon@gmail.com']
  gem.description = 'Minitest integration for mutest'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/backus/mutest'
  gem.license     = 'MIT'

  gem.require_paths    = %w[lib]
  gem.files            = `git ls-files -- lib/mutest/{minitest,/integration/minitest.rb}`.split("\n")
  gem.test_files       = `git ls-files -- spec/integration/mutest/minitest.rb`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE]

  gem.add_runtime_dependency('minitest', '~> 5.11')
  gem.add_runtime_dependency('mutest',   "~> #{gem.version}")
end
