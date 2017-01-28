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
            s(:def, :foo, s(:args), s(:zsuper)), s(:send, nil, :memoize, s(:args, s(:sym, :foo))))
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
