module Mutest
  # An AST Parser
  class Parser
    include Equalizer.new
    include Adamantium::Mutable

    # Initialize object
    #
    # @return [undefined]
    def initialize
      @cache = {}
    end

    # Parse path into AST
    #
    # @param [Pathname] path
    #
    # @return [AST::Node]
    def open(path)
      @cache[path] ||= SourceFile.read(path)
    end
  end
end
