module Mutest
  module AST
    # Node meta information mixin
    module Meta
      # Metadata for const nodes
      class Const
        include NodePredicates
        include Concord.new(:node)
        include NamedChildren

        children :base, :name

        public :base, :name

        # Test if AST node is possibly a top level constant
        #
        # @return [Boolean]
        def possible_top_level?
          base.nil? || n_cbase?(base)
        end
      end
    end
  end
end
