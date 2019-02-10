module Mutest
  module AST
    # Node meta information mixin
    module Meta
      # Metadata for restarg nodes
      class Restarg
        include Concord.new(:node)
        include NamedChildren

        children :name

        public :name
      end
    end
  end
end
