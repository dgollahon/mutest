module Mutest
  module Actor
    # Sender for messages to acting thread
    class Sender
      include Concord.new(:condition_variable, :mutex, :messages)
      include Adamantium::Flat

      # Send a message to actor
      #
      # @param [Object] message
      #
      # @return [self]
      def call(message)
        mutex.synchronize do
          messages << message
          condition_variable.signal
        end

        self
      end
    end
  end
end
