RSpec.describe Mutest::Context do
  describe '.wrap' do
    subject { described_class.wrap(scope, node) }

    let(:node) { s(:str, 'test') }

    context 'with Module as scope' do
      let(:scope) { Mutest }

      let(:expected) do
        s(:module,
          s(:const, nil, :Mutest),
          s(:str, 'test'))
      end

      it { is_expected.to eql(expected) }
    end

    context 'with Class as scope' do
      let(:scope) { Mutest::Context }

      let(:expected) do
        s(:class,
          s(:const, nil, :Context),
          nil,
          s(:str, 'test'))
      end

      it { is_expected.to eql(expected) }
    end
  end

  let(:object)      { described_class.new(scope, source_path) }
  let(:source_path) { instance_double(Pathname)               }
  let(:scope)       { TestApp::Literal                        }

  describe '#identification' do
    subject { object.identification }

    it { is_expected.to eql(scope.name) }
  end

  describe '#root' do
    subject { object.root(node) }

    let(:node) { s(:sym, :node) }

    let(:expected_source) do
      generate(parse(<<-RUBY))
        module TestApp
          class Literal
            :node
          end
        end
      RUBY
    end

    let(:generated_source) do
      Unparser.unparse(subject)
    end

    it 'creates correct source' do
      expect(generated_source).to eql(expected_source)
    end
  end

  describe '#unqualified_name' do
    subject { object.unqualified_name }

    context 'with top level constant name' do
      let(:scope) { TestApp }

      it 'returns the unqualified name' do
        is_expected.to eql('TestApp')
      end

      it_should_behave_like 'an idempotent method'
    end

    context 'with scoped constant name' do
      it 'returns the unqualified name' do
        is_expected.to eql('Literal')
      end

      it_should_behave_like 'an idempotent method'
    end
  end

  describe '#match_expressions' do
    subject { object.match_expressions }

    context 'on toplevel scope' do
      let(:scope) { TestApp }

      it { is_expected.to eql([parse_expression('TestApp*')]) }
    end

    context 'on nested scope' do
      specify do
        is_expected.to eql(
          [
            parse_expression('TestApp::Literal*'),
            parse_expression('TestApp*')
          ]
        )
      end
    end
  end
end
