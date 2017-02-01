module Mutest
  class Mutator
    class Node
      # Abstract mutator for literal AST nodes
      class Literal < self
        include AbstractType

        private

        # Emit values
        #
        # @return [undefined]
        def emit_values
          value_changes.each do |tag, value|
            emit_type(tag, value)
          end
        end
      end # Literal
    end # Node
  end # Mutator
end # Mutest
