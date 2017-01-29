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
require 'devtools/spec_helper'
require 'unparser/cli'
require 'mutest'
require 'mutest/meta'

$LOAD_PATH << File.join(TestApp.root, 'lib')

require 'test_app'

module Fixtures
  TEST_CONFIG = Mutest::Config::DEFAULT.with(reporter: Mutest::Reporter::Null.new)
  TEST_ENV    = Mutest::Env::Bootstrap.(TEST_CONFIG)
end # Fixtures

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
end # ParserHelper

module MessageHelper
  def message(*arguments)
    Mutest::Actor::Message.new(*arguments)
  end
end # MessageHelper

RSpec.configure do |config|
  config.extend(SharedContext)
  config.include(CompressHelper)
  config.include(MessageHelper)
  config.include(ParserHelper)
  config.include(Mutest::AST::Sexp)

  config.after(:suite) do
    $stderr = STDERR
    MutestSpec::Warning.assert_no_warnings
  end
end
