module Mutest
  module Meta
    class Example
      include Anima.new(:file, :node, :node_type, :expected)
      include Adamantium

      # Verification instance for example
      #
      # @return [Verification]
      def verification
        Verification.new(self, generated)
      end

      # Normalized source
      #
      # @return [String]
      def source
        Unparser.unparse(node)
      end
      memoize :source

      # Generated mutations on example source
      #
      # @return [Enumerable<Mutest::Mutation>]
      def generated
        Mutator.mutate(node).map do |node|
          Mutation::Evil.new(self, node)
        end
      end
      memoize :generated
    end
  end
end
