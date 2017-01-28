RSpec.describe Mutest::Subject::Method::Instance do
  let(:object)  { described_class.new(context, node) }

  let(:context) do
    Mutest::Context.new(
      scope,
      instance_double(Pathname)
    )
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
      Mutest::Context.new(scope, instance_double(Pathname))
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

RSpec.describe Mutest::Subject::Method::Instance::Memoized do
  let(:object)  { described_class.new(context, node) }
  let(:context) { double('Context')                  }

  let(:node) do
    s(:def, :foo, s(:args))
  end

  describe '#prepare' do
    subject { object.prepare }

    let(:context) do
      Mutest::Context.new(scope, double('Source Path'))
    end

    let(:scope) do
      Class.new do
        include Memoizable
        def foo
        end
        memoize :foo
      end
    end

    it 'undefines memoizer' do
      expect { subject }.to change { scope.memoized?(:foo) }.from(true).to(false)
    end

    it 'undefines method on scope' do
      expect { subject }.to change { scope.instance_methods.include?(:foo) }.from(true).to(false)
    end

    it_should_behave_like 'a command method'
  end

  describe '#mutations', mutest_expression: 'Mutest::Subject#mutations' do
    subject { object.mutations }

    let(:expected) do
      [
        Mutest::Mutation::Neutral.new(
          object,
          s(:begin,
            s(:def, :foo, s(:args)), s(:send, nil, :memoize, s(:args, s(:sym, :foo))))
        ),
        Mutest::Mutation::Evil.new(
          object,
          s(:begin,
            s(:def, :foo, s(:args), s(:send, nil, :raise)), s(:send, nil, :memoize, s(:args, s(:sym, :foo))))
        ),
        Mutest::Mutation::Evil.new(
          object,
          s(:begin,
            s(:def, :foo, s(:args), nil), s(:send, nil, :memoize, s(:args, s(:sym, :foo))))
        )
      ]
    end

    it { is_expected.to eql(expected) }
  end

  describe '#source' do
    subject { object.source }

    it { is_expected.to eql("def foo\nend\nmemoize(:foo)") }
  end
end
