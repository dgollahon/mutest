module Mutest
  module AST
    # Node meta information mixin
    module Meta
      # Metadata for symbol nodes
      class Symbol
        include Concord.new(:node)
        include NamedChildren

        children :name

        public :name
      end
    end
  end
end
