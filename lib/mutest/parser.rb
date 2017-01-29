module Mutest
  # An AST Parser
  class Parser
    include Adamantium::Mutable, Equalizer.new

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
    def parse(path)
      read(path).ast
    end

    # Extract comments from path
    #
    # @param [Pathname] path
    #
    # @return [Parser::Source::Comment]
    def comments(path)
      read(path).comments
    end

    private

    def read(path)
      @cache[path] ||= SourceFile.parse(path.read)
    end
  end # Parser
end # Mutest
