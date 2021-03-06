module Mutest
  class Mutator
    class Node
      module Regexp
        # Mutator for one-or-more quantifier, `+`
        class OneOrMore < Node
          MAP = IceNine.deep_freeze(
            regexp_greedy_one_or_more:     :regexp_greedy_interval,
            regexp_reluctant_one_or_more:  :regexp_reluctant_interval,
            regexp_possessive_one_or_more: :regexp_possessive_interval
          )

          # -1 marks an infinite upper bound
          UNBOUNDED = -1

          handle(*MAP.keys)

          children :min, :max, :subject

          # Replace `/a+/` with `/a{2,}/`, `/a+?/` with `/a{2,}?/`, and `/a++/` with `/a{2,}+/`
          #
          # @return [undefined]
          def dispatch
            emit(s(MAP.fetch(node.type), 2, UNBOUNDED, subject))
            emit_subject_mutations
            emit(subject)
          end

          private_constant(*constants(false))
        end
      end
    end
  end
end
