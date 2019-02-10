Mutest::Meta::Example::ALL.each.group_by(&:node_type).each do |type, examples|
  RSpec.describe Mutest::Mutator::REGISTRY.lookup(type) do
    toplevel_nodes = examples.map { |example| example.node.type }.uniq

    it "generates the correct mutations on #{toplevel_nodes} toplevel examples" do
      examples.each do |example|
        verification = example.verification
        raise verification.error_report unless verification.success?
      end
    end
  end
end

RSpec.describe Mutest::Mutator::Node do
  describe 'internal DSL' do
    let(:klass) do
      Class.new(described_class) do
        children(:left, :right)

        def dispatch
          left
          emit_left(s(:nil))
          emit_left_mutations
          emit_right_mutations { false }
        end
      end
    end

    def apply
      klass.call(s(:and, s(:true), s(:true)), ->(_) {})
    end

    specify do
      expect(apply).to eql([
        s(:and, s(:nil),   s(:true)),
        s(:and, s(:false), s(:true))
      ].to_set)
    end
  end
end
