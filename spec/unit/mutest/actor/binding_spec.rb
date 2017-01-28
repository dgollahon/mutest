RSpec.describe Mutest::Actor::Binding do
  let(:actor_a)    { instance_double(Mutest::Actor::Mailbox, sender: sender_a, receiver: receiver_a) }
  let(:sender_a)   { instance_double(Mutest::Actor::Sender)                                          }
  let(:sender_b)   { instance_double(Mutest::Actor::Sender)                                          }
  let(:receiver_a) { instance_double(Mutest::Actor::Receiver)                                        }
  let(:payload)    { instance_double(Object)                                                         }
  let(:type)       { instance_double(Symbol)                                                         }

  let(:object) { described_class.new(actor_a, sender_b) }

  describe '#call' do
    subject { object.call(type) }

    before do
      expect(sender_b).to receive(:call).with(message(type, sender_a)).ordered
      expect(receiver_a).to receive(:call).ordered.and_return(message(response_type, payload))
    end

    context 'when return type equals request type' do
      let(:response_type) { type }
      it { is_expected.to be(payload) }
    end

    context 'when return type NOT equals request type' do
      let(:response_type) { double('Other Type') }

      it 'raises error' do
        expect { subject }.to raise_error(Mutest::Actor::ProtocolError, "Expected #{type} but got #{response_type}")
      end
    end
  end
end
