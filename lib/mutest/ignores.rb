module Mutest
  class Ignores
    include Equalizer.new(:disable_lines), Adamantium::Flat

    COMMENT_TEXT = '# mutest:disable'.freeze

    def initialize(comments)
      @comments = comments
    end

    # TODO: Support multiple lines of comments preceeding a disable
    # TODO: Support inline comment disable
    def ignored?(node)
      location = node.location
      return false unless location.expression

      disable_lines.include?(location.line)
    end

    protected

    def disable_lines
      disable_comments.map do |comment|
        comment.location.line + 1
      end
    end
    memoize :disable_lines

    private

    attr_reader :comments

    def disable_comments
      comments.select do |comment|
        comment.text.eql?(COMMENT_TEXT)
      end
    end
  end # Ignores
end # Mutest
