RSpec.describe Mutest::Parser do
  let(:object) { described_class.new       }
  let(:path)   { instance_double(Pathname) }
  let(:source) { ':source'                 }

  before do
    expect(path).to receive(:read)
      .with(no_args)
      .and_return(source)
  end

  describe '#open' do
    subject { object.open(path) }

    it 'returns source file' do
      expect(subject).to eql(Mutest::SourceFile.new(path, s(:sym, :source), nil))
    end

    it 'is idempotent' do
      source = object.open(path)
      expect(subject).to be(source)
    end
  end
end
