RSpec.describe Mutest::Actor::Message do
  let(:type)    { instance_double(Symbol) }
  let(:payload) { instance_double(Object) }

  describe '.new' do
    subject { described_class.new(*arguments) }

    context 'with one argument' do
      let(:arguments) { [type] }

      its(:type)    { is_expected.to be(type)                     }
      its(:payload) { is_expected.to be(Mutest::Actor::Undefined) }
    end

    context 'with two arguments' do
      let(:arguments) { [type, payload] }

      its(:type)    { is_expected.to be(type)    }
      its(:payload) { is_expected.to be(payload) }
    end
  end
end
