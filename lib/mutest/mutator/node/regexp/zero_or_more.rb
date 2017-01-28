module Mutest
  class Mutator
    class Node
      module Regexp
        # Mutator for zero-or-more quantifier, `*`
        class ZeroOrMore < Node
          MAP = IceNine.deep_freeze(
            regexp_greedy_zero_or_more:     :regexp_greedy_one_or_more,
            regexp_reluctant_zero_or_more:  :regexp_reluctant_one_or_more,
            regexp_possessive_zero_or_more: :regexp_possessive_one_or_more
          )

          handle(*MAP.keys)

          children :min, :max, :subject

          # Replace `/a*/` with `/a+/`, `/a*?/` with `/a+?/`, and `/a*+/` with `/a++/`
          #
          # @return [undefined]
          def dispatch
            emit(s(MAP.fetch(node.type), *children))
            emit_subject_mutations
            emit(subject)
          end
        end # GreedyZeroOrMore
      end # Regexp
    end # Node
  end # Mutator
end # Mutest
