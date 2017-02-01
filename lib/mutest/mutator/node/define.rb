module Mutest
  class Mutator
    class Node
      # Namespace for define mutations
      class Define < self
        private

        # Emit mutations
        #
        # @return [undefined]
        def dispatch
          emit_arguments_mutations
          emit_optarg_body_assignments
          emit_restarg_body_mutation
          emit_body(:ReplaceRaise, N_RAISE)
          emit_body(:ReplaceSuper, N_ZSUPER)
          emit_body(:RemoveBody, nil)
          emit_body_mutations if body
        end

        # Emit mutations with optional arguments as assignments in method
        #
        # @return [undefined]
        def emit_optarg_body_assignments
          arguments.children.each do |argument|
            next unless n_optarg?(argument) && AST::Meta::Optarg.new(argument).used?

            emit_body_prepend(:InlineOptional, s(:lvasgn, *argument))
          end
        end

        # Emit mutation with arg splat as empty array assignment in method
        #
        # @return [undefined]
        def emit_restarg_body_mutation
          arguments.children.each do |argument|
            replacement =
              if n_restarg?(argument)
                s(:array)
              elsif n_kwrestarg?(argument)
                s(:hash)
              end

            next unless replacement && argument.children.one?

            emit_body_prepend(:InlineRestarg, s(:lvasgn, AST::Meta::Restarg.new(argument).name, replacement))
          end
        end

        # Emit valid body ASTs depending on instance body
        #
        # @param node [Parser::AST::Node]
        #
        # @return [undefined]
        def emit_body_prepend(label, node)
          if body
            emit_body(label, s(:begin, node, body))
          else
            emit_body(label, node)
          end
        end

        # Mutator for instance method defines
        class Instance < self
          handle :def

          children :name, :arguments, :body
        end # Instance

        # Mutator for singleton method defines
        class Singleton < self
          handle :defs

          children :subject, :name, :arguments, :body
        end # Singleton
      end # Define
    end # Node
  end # Mutator
end # Mutest
