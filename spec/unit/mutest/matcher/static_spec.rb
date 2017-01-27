RSpec.describe Mutest::Matcher::Static, '#call' do
  let(:object)   { described_class.new(subjects) }
  let(:env)      { instance_double(Mutest::Env)  }
  let(:subjects) { instance_double(Array)        }

  subject { object.call(env) }

  it 'returns its predefined subjects' do
    should be(subjects)
  end
end
