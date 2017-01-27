module Mutest
  class Mutator
    class Node
      class Literal
        # Mutator for nil literals
        class Nil < self
          handle(:nil)

          private

          # Emit mutations
          #
          # @return [undefined]
          def dispatch; end
        end # Nil
      end # Literal
    end # Node
  end # Mutator
end # Mutest
