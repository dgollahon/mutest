module Mutest
  # Abstract base class mutest test framework integrations
  class Integration
    include Concord.new(:config)
    include Adamantium::Flat
    include AbstractType

    # Setup integration
    #
    # Integrations are supposed to define a constant under
    # Mutest::Integration named after the capitalized +name+
    # parameter.
    #
    # This avoids having to maintain a mutable registry.
    #
    # @param kernel [Kernel]
    # @param name [String]
    #
    # @return [Class<Integration>]
    def self.setup(kernel, name)
      kernel.require("mutest/integration/#{name}")
      const_get(name.capitalize)
    end

    # Perform integration setup
    #
    # @return [self]
    def setup
      self
    end

    # Run a collection of tests
    #
    # @param [Enumerable<Test>] tests
    #
    # @return [Result::Test]
    abstract_method :call

    # Available tests for integration
    #
    # @return [Enumerable<Test>]
    abstract_method :all_tests

    private

    # Expression parser
    #
    # @return [Expression::Parser]
    def expression_parser
      config.expression_parser
    end
  end
end
