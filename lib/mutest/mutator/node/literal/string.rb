module Mutest
  class Mutator
    class Node
      class Literal
        # Mutator for string literals
        class String < self
          handle(:str)

          children :value

          private

          # Emit mutations
          #
          # @return [undefined]
          def dispatch
            emit_singletons
            emit_type(value + Util::Symbol::POSTFIX)
          end
        end # String
      end # Literal
    end # Node
  end # Mutator
end # Mutest
