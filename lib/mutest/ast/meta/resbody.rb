module Mutest
  module AST
    # Node meta information mixin
    module Meta
      # Metadata for resbody nodes
      class Resbody
        include Concord.new(:node)
        include NamedChildren

        children :captures, :assignment, :body

        public :captures, :assignment, :body
      end
    end
  end
end
