RSpec.describe Mutest::Actor::Mailbox do
  let(:mutex)              { instance_double(Mutex)             }
  let(:condition_variable) { instance_double(ConditionVariable) }

  before do
    allow(Mutex).to receive(:new).and_return(mutex)
    allow(ConditionVariable).to receive(:new).and_return(condition_variable)
  end

  describe '.new' do
    subject { described_class.new }

    its(:sender)   { is_expected.to eql(Mutest::Actor::Sender.new(condition_variable, mutex, []))   }
    its(:receiver) { is_expected.to eql(Mutest::Actor::Receiver.new(condition_variable, mutex, [])) }
  end

  describe '#bind' do
    subject { object.bind(other) }

    let(:object) { described_class.new                    }
    let(:other)  { instance_double(Mutest::Actor::Sender) }

    it { is_expected.to eql(Mutest::Actor::Binding.new(object, other)) }
  end
end
