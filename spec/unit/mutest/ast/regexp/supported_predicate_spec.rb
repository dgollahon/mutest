RSpec.describe Mutest::AST::Regexp, '.supported?' do
  subject { described_class.supported?(expression) }

  let(:expression) { described_class.parse(regexp) }
  let(:regexp)     { /foo/                         }

  it { is_expected.to be(true) }

  context 'conditional regular expressions' do
    let(:regexp) { /((?(1)(foo)(bar)))/ }

    it { is_expected.to be(false) }
  end
end
