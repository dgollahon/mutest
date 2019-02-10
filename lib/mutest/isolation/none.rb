module Mutest
  # Module providing isolation
  class Isolation
    Error = Class.new(RuntimeError)

    # Absolutly no isolation
    #
    # Only useful for debugging.
    class None < self
      # Call block in no isolation
      #
      # @return [Object]
      #
      # @raise [Error]
      #   if block terminates abnormal
      def call
        yield
      rescue StandardError => exception
        raise Error, exception
      end
    end
  end
end
