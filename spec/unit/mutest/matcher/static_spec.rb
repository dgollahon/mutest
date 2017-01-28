RSpec.describe Mutest::Matcher::Static, '#call' do
  subject { object.call(env) }

  let(:object)   { described_class.new(subjects) }
  let(:env)      { instance_double(Mutest::Env)  }
  let(:subjects) { instance_double(Array)        }

  it 'returns its predefined subjects' do
    is_expected.to be(subjects)
  end
end
