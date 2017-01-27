RSpec.describe Mutest::Matcher::Filter, '#call' do
  subject { object.call(env) }

  let(:object)    { described_class.new(matcher, predicate) }
  let(:matcher)   { instance_double(Mutest::Matcher)        }
  let(:subject_a) { instance_double(Mutest::Subject)        }
  let(:subject_b) { instance_double(Mutest::Subject)        }
  let(:env)       { instance_double(Mutest::Env)            }
  let(:predicate) { ->(node) { node.eql?(subject_a) }       }

  before do
    expect(matcher).to receive(:call)
      .with(env)
      .and_return([subject_a, subject_b])
  end

  it 'returns subjects after filtering' do
    should eql([subject_a])
  end
end
