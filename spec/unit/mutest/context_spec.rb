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
      let(:scope) { described_class }

      let(:expected) do
        s(:class,
          s(:const, nil, :Context),
          nil,
          s(:str, 'test'))
      end

      it { is_expected.to eql(expected) }
    end
  end

  let(:source_path) { instance_double(Pathname) }
  let(:scope)       { TestApp::Literal          }

  let(:object) do
    described_class.new(scope, instance_double(Mutest::SourceFile))
  end

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

      it_behaves_like 'an idempotent method'
    end

    context 'with scoped constant name' do
      it 'returns the unqualified name' do
        is_expected.to eql('Literal')
      end

      it_behaves_like 'an idempotent method'
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

  describe '#source_path' do
    let(:source_file) do
      instance_double(Mutest::SourceFile, path: instance_double(Pathname))
    end

    it 'exposes source file path' do
      expect(described_class.new(scope, source_file).source_path).to be(source_file.path)
    end
  end

  describe '#ignore?' do
    let(:object) do
      described_class.new(scope, source_file)
    end

    let(:source_file) { instance_double(Mutest::SourceFile) }
    let(:node) { s(:node) }

    before do
      allow(source_file).to receive(:ignore?).with(node).and_return(ignore)
    end

    context 'when comment disables the node' do
      let(:ignore) { true }

      it 'ignores the node' do
        expect(object.ignore?(node)).to be(true)
      end
    end

    context 'when comment does not disable the node' do
      let(:ignore) { false }

      it 'ignores the node' do
        expect(object.ignore?(node)).to be(false)
      end
    end
  end
end
