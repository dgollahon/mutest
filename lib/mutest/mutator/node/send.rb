module Mutest
  class Mutator
    class Node
      # Namespace for send mutators
      # rubocop:disable ClassLength
      class Send < self
        include AST::Types

        handle(:send)

        children :receiver, :selector

        SELECTOR_REPLACEMENTS = IceNine.deep_freeze(
          __send__:      %i[public_send],
          :< =>          %i[== eql? equal?],
          :<= =>         %i[< == eql? equal?],
          :== =>         %i[eql? equal?],
          :=== =>        %i[kind_of?],
          :> =>          %i[== eql? equal?],
          :>= =>         %i[> == eql? equal?],
          '=~':          %i[match?],
          at:            %i[fetch key?],
          eql?:          %i[equal?],
          fetch:         %i[key?],
          first:         %i[last],
          flat_map:      %i[map],
          grep_v:        %i[grep],
          grep:          %i[grep_v],
          gsub:          %i[sub],
          is_a?:         %i[instance_of?],
          kind_of?:      %i[instance_of?],
          last:          %i[first],
          map:           %i[each],
          match:         %i[match?],
          method:        %i[public_method],
          pop:           %i[last],
          reject:        %i[select],
          reverse_each:  %i[each],
          reverse_map:   %i[map each],
          reverse_merge: %i[merge],
          sample:        %i[first last],
          select:        %i[reject],
          send:          %i[public_send __send__],
          shift:         %i[first],
          to_a:          %i[to_ary to_set],
          to_h:          %i[to_hash],
          to_i:          %i[to_int],
          to_s:          %i[to_str],
          values_at:     %i[fetch_values]
        )

        RECEIVER_SELECTOR_REPLACEMENTS = IceNine.deep_freeze(
          Date: {
            parse: %i[jd civil strptime iso8601 rfc3339 xmlschema rfc2822 rfc822 httpdate jisx0301]
          }
        )

        private

        # Emit mutations
        #
        # @return [undefined]
        def dispatch
          emit_singletons

          if meta.binary_method_operator?
            run(Binary)
          elsif meta.attribute_assignment?
            run(AttributeAssignment)
          else
            normal_dispatch
          end
        end

        # AST metadata for node
        #
        # @return [AST::Meta::Send]
        def meta
          AST::Meta::Send.new(node)
        end
        memoize :meta

        # Arguments being send
        #
        # @return [Enumerable<Parser::AST::Node>]
        alias_method :arguments, :remaining_children
        private :arguments

        # Perform normal, non special case dispatch
        #
        # @return [undefined]
        def normal_dispatch
          emit_naked_receiver
          emit_selector_replacement
          emit_selector_specific_mutations
          emit_argument_propagation
          emit_receiver_selector_mutations
          mutate_receiver
          mutate_arguments
        end

        # Emit mutations which only correspond to one selector
        #
        # @return [undefined]
        def emit_selector_specific_mutations
          emit_method_method_selector_replacements
          emit_const_get_mutation
          emit_integer_mutation
          emit_array_mutation
          emit_dig_mutation
          emit_double_negation_mutation
          emit_lambda_mutation
        end

        # Emit selector mutations specific to top level constants
        #
        # @return [undefined]
        def emit_receiver_selector_mutations
          return unless meta.receiver_possible_top_level_const?

          RECEIVER_SELECTOR_REPLACEMENTS
            .fetch(receiver.children.last, EMPTY_HASH)
            .fetch(selector, EMPTY_ARRAY)
            .each(&public_method(:emit_selector))
        end

        # Emit selector mutations for [public_]method calls
        #
        # - Mutates `foo.method(:to_s)` to `foo.method(:to_str)`
        # - Mutates `foo.public_method('to_s')` to `foo.public_method('to_str')`
        #
        # @return [undefined]
        def emit_method_method_selector_replacements
          return unless meta.method_object_selector? && meta.arguments.one?

          arg = Mutest::Util.one(meta.arguments)

          return unless n_sym?(arg) || n_str?(arg)

          selector_replacements(*arg).each do |replacement|
            emit_type(receiver, selector, s(arg.type, replacement))
          end
        end

        # Emit mutation from `!!foo` to `foo`
        #
        # @return [undefined]
        def emit_double_negation_mutation
          return unless selector.equal?(:!) && n_send?(receiver)

          negated = AST::Meta::Send.new(meta.receiver)
          emit(negated.receiver) if negated.selector.equal?(:!)
        end

        # Emit mutation from proc definition to lambda
        #
        # @return [undefined]
        def emit_lambda_mutation
          emit_type(nil, :lambda) if meta.proc?
        end

        # Emit mutation for `#dig`
        #
        # - Mutates `foo.dig(a, b)` to `foo.fetch(a).dig(b)`
        # - Mutates `foo.dig(a)` to `foo.fetch(a)`
        #
        # @return [undefined]
        def emit_dig_mutation
          return if !selector.equal?(:dig) || arguments.none?

          head, *tail = arguments

          fetch_mutation = s(:send, receiver, :fetch, head)

          return emit(fetch_mutation) if tail.empty?

          emit_type(fetch_mutation, :dig, *tail)
        end

        # Emit mutation from `to_i` to `Integer(...)`
        #
        # @return [undefined]
        def emit_integer_mutation
          return unless selector.equal?(:to_i)

          emit_type(nil, :Integer, receiver)
        end

        # Emit mutation from `Array(a)` to `[a]`
        #
        # @return [undefined]
        def emit_array_mutation
          return unless selector.equal?(:Array) && receiver.nil?

          emit(s(:array, *arguments))
        end

        # Emit mutation from `const_get` to const literal
        #
        # @return [undefined]
        def emit_const_get_mutation
          return unless selector.equal?(:const_get) && n_sym?(arguments.first)

          emit(s(:const, receiver, AST::Meta::Symbol.new(arguments.first).name))
        end

        # Emit selector replacement
        #
        # @return [undefined]
        def emit_selector_replacement
          selector_replacements(selector).each(&public_method(:emit_selector))
        end

        # Emit naked receiver mutation
        #
        # @return [undefined]
        def emit_naked_receiver
          emit(receiver) if receiver
        end

        # Mutate arguments
        #
        # @return [undefined]
        def mutate_arguments
          emit_type(receiver, selector)
          remaining_children_with_index.each do |_node, index|
            mutate_child(index)
            delete_child(index)
          end
        end

        # Emit argument propagation
        #
        # @return [undefined]
        def emit_argument_propagation
          emit_propagation(Mutest::Util.one(arguments)) if arguments.one?
        end

        # Emit receiver mutations
        #
        # @return [undefined]
        def mutate_receiver
          return unless receiver

          emit_implicit_self
          emit_receiver_mutations do |node|
            !n_nil?(node)
          end
        end

        # Emit implicit self mutation
        #
        # @return [undefined]
        def emit_implicit_self
          emit_receiver(nil) if n_self?(receiver) && !(
            KEYWORDS.include?(selector)         ||
            METHOD_OPERATORS.include?(selector) ||
            meta.attribute_assignment?
          )
        end

        def selector_replacements(selector)
          replacements = SELECTOR_REPLACEMENTS.fetch(selector.to_sym, EMPTY_ARRAY)

          if selector.instance_of?(String)
            replacements.map(&:to_s)
          else
            replacements
          end
        end
      end
    end
  end
end
