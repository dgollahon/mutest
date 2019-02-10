require 'mutest/actor'

# A fake actor used from specs
module FakeActor
  class Expectation
    include Concord::Public.new(:name, :message, :block)
    include Equalizer.new(:name, :message)

    def self.new(_name, _message, _block = nil)
      super
    end

    def verify(other)
      raise "Got:\n#{other.inspect}\nExpected:\n#{inspect}" unless eql?(other)

      block&.call(other.message)
    end
  end

  class MessageSequence
    include Concord::Public.new(:messages)
    include Adamantium::Flat

    def self.new
      super([])
    end

    def add(name, *message_arguments, &block)
      messages << Expectation.new(name, Mutest::Actor::Message.new(*message_arguments), block)
      self
    end

    def sending(expectation)
      raise "Unexpected send: #{expectation.inspect}" if messages.empty?

      expected = messages.shift
      expected.verify(expectation)
      self
    end

    def receiving(name)
      raise "No message to read for #{name.inspect}" if messages.empty?

      expected = messages.shift
      raise "Unexpected message #{expected.inspect} for #{name.inspect}" unless expected.name.eql?(name)

      expected.message
    end

    def consumed?
      messages.empty?
    end
  end

  class Env
    include Concord.new(:messages, :mailbox_names)

    def spawn
      mailbox = mailbox(next_name)
      yield mailbox if block_given?
      mailbox.sender
    end

    def mailbox(name)
      Mailbox.new(name, @messages)
    end

    def new_mailbox
      mailbox(:current)
    end

    private

    def next_name
      @mailbox_names.shift.tap do |name|
        name or raise 'Tried to spawn actor when no name available'
      end
    end
  end

  class Mailbox
    include Concord.new(:name, :messages)

    def receiver
      Receiver.new(name, messages)
    end

    def sender
      Sender.new(name, messages)
    end

    def bind(sender)
      Mutest::Actor::Binding.new(self, sender)
    end
  end

  class Sender
    include Concord.new(:name, :messages)

    def call(message)
      messages.sending(Expectation.new(name, message))
    end
  end

  class Receiver
    include Concord::Public.new(:name, :messages)

    def call
      messages.receiving(name)
    end
  end
end
