module Mutest
  class Mutator
    class Util
      # Utility symbol mutator
      class Symbol < self
        POSTFIX = '__mutest__'.freeze

        private

        # Emit mutations
        #
        # @return [undefined]
        def dispatch
          emit((input.to_s + POSTFIX).to_sym)
        end
      end
    end
  end
end
