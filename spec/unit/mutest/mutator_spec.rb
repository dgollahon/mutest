RSpec.describe Mutest::Mutator do
  subject do
    Class.new(described_class) do
      const_set(:REGISTRY, Mutest::Registry.new)

      handle :send

      def dispatch
        emit(parent)
      end
    end
  end

  describe '.handle' do
    it 'registers mutator' do
      mutations = subject.mutate(s(:send), ->(_) {}, s(:parent))
      expect(mutations).to eql([s(:parent)].to_set)
    end
  end

  context 'when dispatch is disabled' do
    it 'does not produce mutations' do
      input     = s(:send)
      filter    = ->(node) { node.equal?(input) }
      mutations = subject.mutate(input, filter, s(:parent))

      expect(mutations.empty?).to be(true)
    end
  end
end
