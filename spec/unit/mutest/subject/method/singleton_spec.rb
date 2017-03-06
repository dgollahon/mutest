RSpec.describe Mutest::Subject::Method::Singleton do
  let(:object)  { described_class.new(context, node) }
  let(:node)    { s(:defs, s(:self), :foo, s(:args)) }

  let(:context) do
    Mutest::Context.new(scope, instance_double(Mutest::SourceFile))
  end

  let(:scope) do
    Class.new do
      def self.foo
      end

      def self.name
        'Test'
      end
    end
  end

  describe '#expression' do
    subject { object.expression }

    it { is_expected.to eql(parse_expression('Test.foo')) }

    it_behaves_like 'an idempotent method'
  end

  describe '#match_expression' do
    subject { object.match_expressions }

    it { is_expected.to eql(%w[Test.foo Test*].map(&method(:parse_expression))) }

    it_behaves_like 'an idempotent method'
  end

  describe '#prepare' do
    subject { object.prepare }

    it 'undefines method on scope' do
      expect { subject }.to change { scope.methods.include?(:foo) }.from(true).to(false)
    end

    it_behaves_like 'a command method'
  end

  describe '#source' do
    subject { object.source }

    it { is_expected.to eql("def self.foo\nend") }
  end
end
