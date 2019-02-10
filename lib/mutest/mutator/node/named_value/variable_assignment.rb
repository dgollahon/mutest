module Mutest
  class Mutator
    class Node
      module NamedValue
        # Mutation emitter to handle variable assignment nodes
        class VariableAssignment < Node
          children :name, :value

          map = {
            gvasgn: '$',
            cvasgn: '@@',
            ivasgn: '@',
            lvasgn: EMPTY_STRING
          }

          MAP = IceNine.deep_freeze(
            Hash[map.map { |type, prefix| [type, [prefix, /^#{::Regexp.escape(prefix)}/]] }]
          )

          handle(*MAP.keys)

          private

          # Emit mutations
          #
          # @return [undefined]
          def dispatch
            emit_singletons
            mutate_name
            emit_value_mutations if value # op asgn!
          end

          # Emit name mutations
          #
          # @return [undefined]
          def mutate_name
            prefix, regexp = MAP.fetch(node.type)
            stripped = name.to_s.sub(regexp, EMPTY_STRING)
            mutate_with(Util::Symbol, stripped) do |name|
              emit_name(:"#{prefix}#{name}")
            end
          end
        end
      end
    end
  end
end
