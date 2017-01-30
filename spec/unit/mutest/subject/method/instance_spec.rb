RSpec.describe Mutest::Subject::Method::Instance do
  let(:object)  { described_class.new(context, node) }

  let(:context) do
    Mutest::Context.new(scope, instance_double(Mutest::SourceFile))
  end

  let(:node) do
    s(:def, :foo, s(:args))
  end

  let(:scope) do
    Class.new do
      attr_reader :bar

      def initialize
        @bar = :boo
      end

      def foo
      end

      def self.name
        'Test'
      end
    end
  end

  describe '#expression' do
    subject { object.expression }

    it { is_expected.to eql(parse_expression('Test#foo')) }

    it_should_behave_like 'an idempotent method'
  end

  describe '#match_expression' do
    subject { object.match_expressions }

    it { is_expected.to eql(%w[Test#foo Test*].map(&method(:parse_expression))) }

    it_should_behave_like 'an idempotent method'
  end

  describe '#prepare' do
    subject { object.prepare }

    let(:context) do
      Mutest::Context.new(scope, instance_double(Mutest::SourceFile))
    end

    it 'undefines method on scope' do
      expect { subject }.to change { scope.instance_methods.include?(:foo) }.from(true).to(false)
    end

    it_should_behave_like 'a command method'
  end

  describe '#source' do
    subject { object.source }

    it { is_expected.to eql("def foo\nend") }
  end
end
