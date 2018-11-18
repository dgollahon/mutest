require File.expand_path('../lib/mutest/version', __FILE__)

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |gem|
  gem.name        = 'mutest'
  gem.version     = Mutest::VERSION.dup
  gem.authors     = ['Daniel Gollahon', 'John Backus']
  gem.email       = ['johncbackus@gmail.com', 'daniel.gollahon@gmail.com']
  gem.description = 'Mutation testing for ruby'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/backus/mutest'
  gem.license     = 'MIT'

  gem.require_paths = %w[lib]

  exclusion = `git ls-files -- lib/mutant/{minitest,integration}`.split("\n")
    .reject { |filename| filename =~ %r{/null.rb\z} }

  gem.files            = `git ls-files`.split("\n") - exclusion
  gem.test_files       = `git ls-files -- spec/{unit,integration}`.split("\n")
  gem.extra_rdoc_files = %w[LICENSE]
  gem.executables      = %w[mutest]

  gem.required_ruby_version = '>= 2.1'

  gem.add_runtime_dependency('parser',        '>= 2.5.0.1', '< 2.6')
  gem.add_runtime_dependency('ast',           '~> 2.2')
  gem.add_runtime_dependency('diff-lcs',      '~> 1.2')
  gem.add_runtime_dependency('parallel',      '~> 1.3')
  gem.add_runtime_dependency('morpher',       '~> 0.2.6')
  gem.add_runtime_dependency('procto',        '~> 0.0.2')
  gem.add_runtime_dependency('abstract_type', '~> 0.0.7')
  gem.add_runtime_dependency('unparser',      '~> 0.2.5')
  gem.add_runtime_dependency('ice_nine',      '~> 0.11.1')
  gem.add_runtime_dependency('adamantium',    '~> 0.2.0')
  gem.add_runtime_dependency('memoizable',    '~> 0.4.2')
  gem.add_runtime_dependency('equalizer',     '~> 0.0.9')
  gem.add_runtime_dependency('anima',         '~> 0.3.0')
  gem.add_runtime_dependency('concord',       '~> 0.1.5')
  gem.add_runtime_dependency('regexp_parser', '~> 0.4.9')
end
