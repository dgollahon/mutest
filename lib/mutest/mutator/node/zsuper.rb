module Mutest
  class Mutator
    class Node
      # Mutator for super without parentheses
      class ZSuper < self
        handle(:zsuper)

        private

        # Emit mutations
        #
        # @return [undefined]
        def dispatch
          emit_singletons
          emit(:SuperWithoutArguments, N_EMPTY_SUPER)
        end
      end # ZSuper
    end # Node
  end # Mutator
end # Mutest
