module Mutest
  class Mutator
    class Node
      # Kwbegin mutator
      class Kwbegin < Generic
        handle(:kwbegin)

        private

        # Emit mutations
        #
        # @return [undefined]
        def dispatch
          super()
          emit_singletons
        end
      end
    end
  end
end
