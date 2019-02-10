module Mutest
  # Abstract base class for test selectors
  class Selector
    include Adamantium::Flat
    include AbstractType

    # Tests for subject
    #
    # @param [Subject] subjecto
    #
    # @return [Enumerable<Test>]
    abstract_method :call
  end
end
