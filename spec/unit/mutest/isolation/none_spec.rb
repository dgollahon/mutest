RSpec.describe Mutest::Isolation::None do
  describe '.call' do
    let(:object) { described_class.new }

    it 'return block value' do
      expect(object.call { :foo }).to be(:foo)
    end

    it 'wraps *all* exceptions' do
      expect { object.call { fail 'foo' } }.to raise_error(
        Mutest::Isolation::Error,
        'foo'
      )
    end
  end
end
