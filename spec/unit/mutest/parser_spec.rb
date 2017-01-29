RSpec.describe Mutest::Parser do
  let(:object) { described_class.new       }
  let(:path)   { instance_double(Pathname) }
  let(:source) { ':source'                 }

  before do
    expect(path).to receive(:read)
      .with(no_args)
      .and_return(source)
  end

  describe '#parse' do
    subject { object.parse(path) }

    it 'returns parsed source' do
      expect(subject).to eql(s(:sym, :source))
    end

    it 'is idempotent' do
      source = object.parse(path)
      expect(subject).to be(source)
    end
  end

  describe '#comments' do
    let(:source) do
      <<-RUBY
      # This is the foo method
      def foo
        # this is an inline method
      end
      RUBY
    end

    it 'returns comments' do
      expect(object.comments(path).map(&:text)).to contain_exactly(
        '# This is the foo method',
        '# this is an inline method'
      )
    end
  end
end
