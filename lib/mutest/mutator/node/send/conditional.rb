module Mutest
  class Mutator
    class Node
      class Send
        class Conditional < self
          handle(:csend)

          private

          # Emit mutations
          #
          # @return [undefined]
          def dispatch
            super()
            emit(s(:send, *children))
          end
        end
      end
    end
  end
end
