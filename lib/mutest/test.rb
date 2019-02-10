module Mutest
  # Abstract base class for test that might kill a mutation
  class Test
    include Anima.new(
      :expression,
      :id
    )
    include Adamantium::Flat

    # Identification string
    #
    # @return [String]
    alias_method :identification, :id
  end
end
