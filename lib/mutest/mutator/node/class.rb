module Mutest
  class Mutator
    class Node
      # Namespace for class mutations
      class Class < self
        handle :class

        children :klass, :parent, :body

        private

        # Emit mutations only for class body
        #
        # @return [undefined]
        def dispatch
          emit_body_mutations if body
        end
      end
    end
  end
end
