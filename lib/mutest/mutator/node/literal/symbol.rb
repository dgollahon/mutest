module Mutest
  class Mutator
    class Node
      class Literal < self
        # Mutator for symbol literals
        class Symbol < self
          handle(:sym)

          children :value

          PREFIX = '__mutest__'.freeze

          private

          # Emit mutations
          #
          # @return [undefined]
          def dispatch
            emit_singletons
            mutate_with(Util::Symbol, value) do |mutation|
              emit_type(:RenameSymbol, mutation)
            end
          end
        end # Symbol
      end # Literal
    end # Node
  end # Mutator
end # Mutest
