module Mutest
  class Integration
    # Null integration that never kills a mutation
    class Null < self
      # Available tests for integration
      #
      # @return [Enumerable<Test>]
      def all_tests
        EMPTY_ARRAY
      end

      # Run a collection of tests
      #
      # @param [Enumerable<Mutest::Test>] tests
      #
      # @return [Result::Test]
      def call(tests)
        Result::Test.new(
          output:  '',
          passed:  true,
          runtime: 0.0,
          tests:   tests
        )
      end
    end # Null
  end # Integration
end # Mutest
