module Mutest
  class Mutator
    class Node
      module NamedValue
        # Mutation emitter to handle constant assignment nodes
        class ConstantAssignment < Node
          children :cbase, :name, :value

          handle :casgn

          private

          # Emit mutations
          #
          # @return [undefined]
          def dispatch
            mutate_name
            return unless value # op asgn
            emit_value_mutations
            emit_remove_const
          end

          # Emit remove_const
          #
          # @return [undefined]
          def emit_remove_const
            emit(:RemoveConst, s(:send, cbase, :remove_const, s(:sym, name)))
          end

          # Emit name mutations
          #
          # @return [undefined]
          def mutate_name
            mutate_with(Util::Symbol, name) do |name|
              emit_name(:UpcaseConstant, name.upcase)
            end
          end
        end # ConstantAssignment
      end # NamedValue
    end # Node
  end # Mutator
end # Mutest
