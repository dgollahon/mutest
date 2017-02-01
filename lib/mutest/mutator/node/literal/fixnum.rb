module Mutest
  class Mutator
    class Node
      class Literal < self
        # Mutator for fixnum literals
        class Fixnum < self
          handle(:int)

          private

          # Emit mutations
          #
          # @return [undefined]
          def dispatch
            emit_singletons
            emit_values
          end

          # Values to mutate to and corresponding labels
          #
          # @return [Hash]
          def value_changes
            {
              ReplaceWithZero: 0,
              ReplaceWithOne:  1,
              NegateValue:     -value,
              IncrementValue:  value + 1,
              DecrementValue:  value - 1
            }
          end

          # Literal original value
          #
          # @return [Object]
          def value
            children.first
          end
        end # Fixnum
      end # Literal
    end # Node
  end # Mutator
end # Mutest
