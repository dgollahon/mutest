module Mutest
  class Mutator
    class Node
      class Literal < self
        # Mutator for float literals
        class Float < self
          handle(:float)

          private

          # Emit mutations
          #
          # @return [undefined]
          def dispatch
            emit_singletons
            emit_values
            emit_special_cases
          end

          # Emit special cases
          #
          # @return [undefined]
          def emit_special_cases
            emit(:NanFloat, N_NAN)
            emit(:NegativeInfinityFloat, N_NEGATIVE_INFINITY)
            emit(:InfinityFloat, N_INFINITY)
          end

          # Values to mutate to and corresponding labels
          #
          # @return [Hash]
          def value_changes
            original = children.first

            {
              ReplaceWithZero: 0.0,
              ReplaceWithOne:  1.0,
              NegateValue:     -original
            }
          end
        end # Float
      end # Literal
    end # Node
  end # Mutator
end # Mutest
