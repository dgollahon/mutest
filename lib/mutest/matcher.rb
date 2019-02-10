module Mutest
  # Abstract matcher to find subjects to mutate
  class Matcher
    include AbstractType
    include Adamantium::Flat

    # Call matcher
    #
    # @param [Env::Bootstrap] env
    #
    # @return [Enumerable<Subject>]
    #
    abstract_method :call
  end
end
