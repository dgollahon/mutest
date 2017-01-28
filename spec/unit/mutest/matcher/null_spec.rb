RSpec.describe Mutest::Matcher::Null, '#call' do
  subject { object.call(env) }

  let(:object) { described_class.new          }
  let(:env)    { instance_double(Mutest::Env) }

  it 'returns no subjects' do
    is_expected.to eql([])
  end
end
