module Mutest
  class Mutator
    class Node
      # Mutator for arguments node
      class Arguments < self
        handle(:args)

        private

        # Emit mutations
        #
        # @return [undefined]
        def dispatch
          emit_argument_presence
          emit_argument_mutations
          emit_hash_type_hint
          emit_mlhs_expansion
        end

        # Emit argument presence mutation
        #
        # @return [undefined]
        def emit_argument_presence
          emit_type(:RemoveArguments)
          mutate_with(Util::Array::Presence, children) do |children|
            emit_type(:RemoveArgument, *children)
          end
        end

        # Emit argument mutations
        #
        # @return [undefined]
        def emit_argument_mutations
          children.each_with_index do |child, index|
            mutate(child).each do |change|
              next if invalid_argument_replacement?(change.object, index)
              emit_child_update(index, change)
            end
          end
        end

        # Test if child mutation is allowed
        #
        # @param [Parser::AST::Node]
        #
        # @return [Boolean]
        def invalid_argument_replacement?(mutant, index)
          n_arg?(mutant) && children[0...index].any?(&method(:n_optarg?))
        end

        def emit_hash_type_hint
          *first_args, last_arg = children

          return unless last_arg && hintworthy_node?(last_arg)

          last_name = last_arg.children.first

          emit_type(:AddKeywordArgSplat, *first_args, s(:kwrestarg, last_name)) unless last_name.to_s.start_with?('_')
        end

        # Is this a simple arg or arg={} ?
        def hintworthy_node?(node)
          n_arg?(node) ||
            (n_optarg?(node) && node.children.last.eql?(s(:hash)))
        end

        # Emit mlhs expansions
        #
        # @return [undefined]
        def emit_mlhs_expansion
          mlhs_childs_with_index.each do |child, index|
            dup_children = children.dup
            dup_children.delete_at(index)
            dup_children.insert(index, *child)
            emit_type(:ExpandMLHS, *dup_children)
          end
        end

        # Multiple left hand side childs
        #
        # @return [Enumerable<Parser::AST::Node, Fixnum>]
        def mlhs_childs_with_index
          children.each_with_index.select do |child, _index|
            n_mlhs?(child)
          end
        end
      end # Arguments
    end # Node
  end # Mutator
end # Mutest
