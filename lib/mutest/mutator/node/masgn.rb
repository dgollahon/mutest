module Mutest
  class Mutator
    class Node
      # Mutation emitter to handle multiple assignment nodes
      class MultipleAssignment < self
        handle(:masgn)

        children :left, :right

        private

        # Emit mutations
        #
        # @return [undefined]
        def dispatch
          emit_singletons
        end
      end
    end
  end
end
