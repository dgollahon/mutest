module Mutest
  module Parallel
    # Parallel execution worker
    class Worker
      include Anima.new(
        :mailbox,
        :parent,
        :processor
      )
      include Adamantium::Flat

      # Run worker
      #
      # @param [Hash<Symbol, Object>] attributes
      #
      # @return [self]
      def self.run(attributes)
        new(attributes).run
        self
      end

      private_class_method :new

      # Worker loop
      #
      # @return [self]
      #
      # rubocop:disable Lint/Loop
      def run
        begin
          parent.call(Actor::Message.new(:ready, mailbox.sender))
        end until handle(mailbox.receiver.call)
      end

      private

      # Handle job
      #
      # @param [Message] message
      #
      # @return [Boolean]
      def handle(message) # rubocop:disable Metrics/MethodLength
        type    = message.type
        payload = message.payload

        case message.type
        when :job
          handle_job(payload)
          nil
        when :stop
          true
        else
          raise Actor::ProtocolError, "Unknown command: #{type.inspect}"
        end
      end

      # Handle mutation
      #
      # @param [Job] job
      #
      # @return [undefined]
      def handle_job(job)
        result = processor.call(job.payload)

        parent.call(
          Actor::Message.new(
            :result,
            JobResult.new(
              job:     job,
              payload: result
            )
          )
        )
      end
    end
  end
end
