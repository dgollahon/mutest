module Mutest
  module AST
    # Node meta information mixin
    module Meta
      # Metadata for optional argument nodes
      class Optarg
        include Concord.new(:node)
        include NamedChildren

        UNDERSCORE = '_'.freeze

        children :name, :default_value

        public :name, :default_value

        # Test if optarg definition intends to be used
        #
        # @return [Boolean]
        def used?
          !name.to_s.start_with?(UNDERSCORE)
        end
      end
    end
  end
end
