module Mutest
  class Mutator
    class Node
      class BlockPass < self
        handle(:block_pass)

        children :arg

        private

        # Emit mutations
        #
        # @return [undefined]
        def dispatch
          emit_arg_mutations
        end
      end # BlockPass
    end # Node
  end # Mutator
end # Mutest
