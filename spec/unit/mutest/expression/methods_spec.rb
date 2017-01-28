RSpec.describe Mutest::Expression::Methods do
  let(:object) { described_class.new(attributes) }

  describe '#match_length' do
    let(:attributes) { { scope_name: 'TestApp::Literal', scope_symbol: '#' } }

    subject { object.match_length(other) }

    context 'when other is an equivalent expression' do
      let(:other) { parse_expression(object.syntax) }

      it { is_expected.to be(object.syntax.length) }
    end

    context 'when other is matched' do
      let(:other) { parse_expression('TestApp::Literal#foo') }

      it { is_expected.to be(object.syntax.length) }
    end

    context 'when other is an not matched expression' do
      let(:other) { parse_expression('Foo*') }

      it { is_expected.to be(0) }
    end
  end

  describe '#syntax' do
    subject { object.syntax }

    context 'with an instance method' do
      let(:attributes) { { scope_name: 'TestApp::Literal', scope_symbol: '#' } }

      it { is_expected.to eql('TestApp::Literal#') }
    end

    context 'with a singleton method' do
      let(:attributes) { { scope_name: 'TestApp::Literal', scope_symbol: '.' } }

      it { is_expected.to eql('TestApp::Literal.') }
    end
  end

  describe '#matcher' do
    subject { object.matcher }

    context 'with an instance method' do
      let(:attributes) { { scope_name: 'TestApp::Literal', scope_symbol: '#' } }

      it { is_expected.to eql(Mutest::Matcher::Methods::Instance.new(TestApp::Literal)) }
    end

    context 'with a singleton method' do
      let(:attributes) { { scope_name: 'TestApp::Literal', scope_symbol: '.' } }

      it { is_expected.to eql(Mutest::Matcher::Methods::Singleton.new(TestApp::Literal)) }
    end
  end
end
