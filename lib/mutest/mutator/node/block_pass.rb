module Mutest
  class Mutator
    class Node
      class BlockPass < self
        handle(:block_pass)

        children :arg

        private

        # Emit mutations
        #
        # @return [undefined]
        def dispatch
          emit_arg_mutations
          emit_symbol_to_proc_mutations
        end

        def emit_symbol_to_proc_mutations
          return unless n_sym?(arg)

          Send::SELECTOR_REPLACEMENTS.fetch(*arg, EMPTY_ARRAY).each do |method|
            emit_arg(s(:sym, method))
          end
        end
      end # BlockPass
    end # Node
  end # Mutator
end # Mutest
