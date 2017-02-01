module Mutest
  class Mutator
    class Node
      class Send
        # Mutator for sends that correspond to a binary operator
        class Binary < self
          children :left, :operator, :right

          private

          # Emit mutations
          #
          # @return [undefined]
          def dispatch
            emit(:RemoveRight, left)
            emit_left_mutations
            emit_selector_replacement
            emit(:RemoveLeft, right)
            emit_right_mutations
            emit_not_equality_mutations
          end

          # Emit mutations for `!=`
          #
          # @return [undefined]
          def emit_not_equality_mutations
            return unless operator.equal?(:'!=')

            emit_not_equality_mutation(:NotEql, :eql?)
            emit_not_equality_mutation(:NotEqual, :equal?)
          end

          # Emit negated method sends with specified operator
          #
          # @param new_operator [Symbol] selector to be negated
          #
          # @return [undefined]
          def emit_not_equality_mutation(label, new_operator)
            emit(label, n_not(s(:send, left, new_operator, right)))
          end
        end # Binary
      end # Send
    end # Node
  end # Mutator
end # Mutest
