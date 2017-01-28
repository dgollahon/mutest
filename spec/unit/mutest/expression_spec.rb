RSpec.describe Mutest::Expression do
  let(:parser) { Mutest::Config::DEFAULT.expression_parser }

  describe '#prefix?' do
    subject { object.prefix?(other) }

    let(:object) { parser.call('Foo*') }

    context 'when object is a prefix of other' do
      let(:other) { parser.call('Foo::Bar') }

      it { is_expected.to be(true) }
    end

    context 'when other is not a prefix of other' do
      let(:other) { parser.call('Bar') }

      it { is_expected.to be(false) }
    end
  end

  describe '.try_parse' do
    subject { object.try_parse(input) }

    let(:object) do
      Class.new(described_class) do
        include Anima.new(:foo)

        const_set(:REGEXP, /(?<foo>foo)/)
      end
    end

    context 'on successful parse' do
      let(:input) { 'foo' }

      it { is_expected.to eql(object.new(foo: 'foo')) }
    end

    context 'on unsuccessful parse' do
      let(:input) { 'bar' }

      it { is_expected.to be(nil) }
    end
  end
end
