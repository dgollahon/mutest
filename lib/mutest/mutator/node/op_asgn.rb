module Mutest
  class Mutator
    class Node
      # OpAsgn mutator
      class OpAsgn < self
        handle(:op_asgn)

        children :left, :operation, :right

        private

        # Emit mutations
        #
        # @return [undefined]
        def dispatch
          emit_singletons
          emit_left_mutations do |node|
            !n_self?(node)
          end
          emit_right_mutations
          emit_compound_assignment_mutations
        end

        # Mutate compound assignments like `+=` to `+` and `=`
        def emit_compound_assignment_mutations
          case left.type
          when :lvasgn then emit_lvar_mutation
          when :ivasgn then emit_ivar_mutation
          when :send   then emit_send_mutation
          end
        end

        def emit_lvar_mutation
          emit(:ReplaceCompoundWithOperator, s(:send, s(:send, nil, *left), operation, right))
          emit(:ReplaceCompoundWithAssignment, s(:lvasgn, *left, right))
        end

        def emit_ivar_mutation
          emit(:ReplaceCompoundWithOperator, s(:send, s(:ivar, *left), operation, right))
          emit(:ReplaceCompoundWithAssignment, s(:ivasgn, *left, right))
        end

        def emit_send_mutation
          emit(:ReplaceCompoundWithOperator, s(:send, left, operation, right))
          emit(:ReplaceCompoundWithAssignment, s(:send, left.children.first, :"#{left.children.last}=", right))
        end
      end # OpAsgn
    end # Node
  end # Mutator
end # Mutest
