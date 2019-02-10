if ENV['COVERAGE'] == 'true'
  require 'simplecov'

  SimpleCov.start do
    command_name 'spec:unit'

    add_filter 'config'
    add_filter 'spec'
    add_filter 'vendor'
    add_filter 'test_app'
    add_filter 'lib/mutest.rb' # simplecov bug not seeing default block is executed

    minimum_coverage 100
  end
end

# Require warning support first in order to catch any warnings emitted during boot
require_relative './support/warning'
MutestSpec::Warning.hook_under_rspec

require 'tempfile'
require 'concord'
require 'anima'
require 'adamantium'
require 'unparser/cli'
require 'mutest'
require 'mutest/meta'
require 'rspec/its'
require 'timeout'

module MutestSpec
  SPECS_PATH       = Pathname.new(__dir__).expand_path.freeze
  PROJECT_ROOT     = SPECS_PATH.parent.freeze
  UNIT_TEST_TIMOUT = 10.0
end

Dir.glob(MutestSpec::SPECS_PATH.join('{shared,support}/**/*.rb')).each(&method(:require))

$LOAD_PATH << File.join(TestApp.root, 'lib')

require 'test_app'

module Fixtures
  TEST_CONFIG = Mutest::Config::DEFAULT.with(reporter: Mutest::Reporter::Null.new)
  TEST_ENV    = Mutest::Env::Bootstrap.(TEST_CONFIG)
end

module ParserHelper
  def generate(node)
    Unparser.unparse(node)
  end

  def parse(string)
    Unparser::Preprocessor.run(Parser::CurrentRuby.parse(string))
  end

  def parse_expression(string)
    Mutest::Config::DEFAULT.expression_parser.(string)
  end
end

module MessageHelper
  def message(*arguments)
    Mutest::Actor::Message.new(*arguments)
  end
end

RSpec.configure do |config|
  config.extend(SharedContext)
  config.include(CompressHelper)
  config.include(MessageHelper)
  config.include(ParserHelper)
  config.include(Mutest::AST::Sexp)

  # Define metadata for all tests which live under spec/unit
  config.define_derived_metadata(file_path: %r{\bspec/unit/}) do |metadata|
    # Set the type of these tests as 'unit'
    metadata[:type] = :unit
  end

  # Set a modest timeout to kill slow tests when running `mutest`.
  config.around(:each, type: :unit) do |example|
    Timeout.timeout(MutestSpec::UNIT_TEST_TIMOUT, &example)
  end

  config.after(:suite) do
    $stderr = STDERR
    MutestSpec::Warning.assert_no_warnings
  end
end
