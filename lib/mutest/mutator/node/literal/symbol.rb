module Mutest
  class Mutator
    class Node
      class Literal < self
        # Mutator for symbol literals
        class Symbol < self
          handle(:sym)

          children :value

          private

          # Emit mutations
          #
          # @return [undefined]
          def dispatch
            emit_singletons
            mutate_with(Util::Symbol, value, &method(:emit_type))
          end
        end
      end
    end
  end
end
