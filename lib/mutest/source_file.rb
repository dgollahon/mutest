module Mutest
  # A source file representation
  class SourceFile
    include Concord::Public.new(:ast, :comments)

    # Read and parse file with comments
    #
    # @return [undefined]
    def self.parse(source)
      new(*::Parser::CurrentRuby.parse_with_comments(source))
    end
  end # SourceFile
end # Mutest
