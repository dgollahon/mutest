module Mutest
  class Mutator
    class Node
      # Mutator for nth-ref nodes
      class NthRef < self
        handle :nth_ref

        children :number

        private

        # Emit mutations
        #
        # @return [undefined]
        def dispatch
          emit_number(:DecrementLiteral, number - 1) unless number.equal?(1)
          emit_number(:IncrementLiteral, number + 1)
        end
      end # NthRef
    end # Node
  end # Mutator
end # Mutest
