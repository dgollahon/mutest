module Mutest
  # A source file representation
  class SourceFile
    include Concord::Public.new(:path, :ast), Adamantium

    COMMENT_TEXT = '# mutest:disable'.freeze

    # Read and parse file with comments
    #
    # @return [undefined]
    def self.read(path)
      new(path, *::Parser::CurrentRuby.parse_with_comments(path.read))
    end

    def initialize(path, ast, comments)
      super(path, ast)

      @comments = comments
    end

    # TODO: Support multiple lines of comments preceeding a disable
    # TODO: Support inline comment disable
    def ignore?(node)
      location = node.location
      return false unless location && location.expression

      disable_lines.include?(location.line)
    end

    private

    attr_reader :comments

    def disable_lines
      disable_comments.map do |comment|
        comment.location.line + 1
      end
    end
    memoize :disable_lines

    def disable_comments
      comments.select do |comment|
        comment.text.eql?(COMMENT_TEXT)
      end
    end
  end # SourceFile
end # Mutest
