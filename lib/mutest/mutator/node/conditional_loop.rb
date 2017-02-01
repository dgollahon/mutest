module Mutest
  class Mutator
    class Node
      # Mutator for while expressions
      class ConditionalLoop < self
        handle(:until, :while)

        children :condition, :body

        private

        # Emit mutations
        #
        # @return [undefined]
        def dispatch
          emit_singletons
          emit_condition_mutations
          emit_body_mutations if body
          emit_body(:RemoveBody, nil)
          emit_body(:ReplaceRaise, N_RAISE)
        end
      end # ConditionalLoop
    end # Node
  end # Mutator
end # Mutest
