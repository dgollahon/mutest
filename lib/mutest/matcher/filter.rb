module Mutest
  class Matcher
    # Matcher filter
    class Filter < self
      include Concord.new(:matcher, :predicate)

      # Enumerate matches
      #
      # @param [Env::Bootstrap] env
      #
      # @return [Enumerable<Subject>]
      def call(env)
        matcher
          .call(env)
          .select(&predicate.method(:call))
      end
    end
  end
end
