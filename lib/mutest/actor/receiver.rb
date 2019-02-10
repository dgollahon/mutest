module Mutest
  module Actor
    # Receiver side of an actor
    class Receiver
      include Concord.new(:condition_variable, :mutex, :messages)
      include Adamantium::Flat

      # Receives a message, blocking
      #
      # @return [Object]
      def call
        2.times do
          message = try_blocking_receive
          return message unless message.equal?(Undefined)
        end
        raise ProtocolError
      end

      private

      # Try a blocking receive
      #
      # @return [Undefined]
      #   if there is no message yet
      #
      # @return [Object]
      #   if there is a message
      def try_blocking_receive
        mutex.synchronize do
          if messages.empty?
            condition_variable.wait(mutex)
            Undefined
          else
            messages.shift
          end
        end
      end
    end
  end
end
