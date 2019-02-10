module Mutest
  # Class to colorize strings
  class Color
    include Concord.new(:code)
    include Adamantium::Flat

    # Format text with color
    #
    # @param [String] text
    #
    # @return [String]
    def format(text)
      "\e[#{code}m#{text}\e[0m"
    end

    NONE = Class.new(self) do
      # Format null color
      #
      # @param [String] text
      #
      # @return [String]
      #   the argument string
      def format(text)
        text
      end

    private # rubocop:disable AccessModifierIndentation

      # Initialize null color
      #
      # @return [undefined]
      def initialize
      end
    end.new

    RED   = Color.new(31)
    GREEN = Color.new(32)
    BLUE  = Color.new(34)
  end
end
