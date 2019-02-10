module Mutest
  class Mutator
    class Node
      # Mutator for multiple assignment left hand side nodes
      class MLHS < self
        handle(:mlhs)

        private

        # Emit mutations
        #
        # @return [undefined]
        def dispatch
          mutate_single_child do |_child, index|
            delete_child(index)
          end
        end
      end
    end
  end
end
