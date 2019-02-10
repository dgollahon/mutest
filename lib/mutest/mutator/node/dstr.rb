module Mutest
  class Mutator
    class Node
      # Dstr mutator
      class Dstr < Generic
        handle(:dstr)

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
