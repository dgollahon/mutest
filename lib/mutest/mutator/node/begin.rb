module Mutest
  class Mutator
    class Node
      # Mutator for begin nodes
      class Begin < self
        handle(:begin)

        private

        # Emit mutations
        #
        # @return [undefined]
        def dispatch
          mutate_single_child do |child|
            emit(child)
          end
        end
      end
    end
  end
end
