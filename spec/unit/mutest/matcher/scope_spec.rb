RSpec.describe Mutest::Matcher::Scope, '#call' do
  let(:scope)     { TestApp }
  let(:object)    { described_class.new(scope)       }
  let(:env)       { instance_double(Mutest::Env)     }
  let(:matcher_a) { instance_double(Mutest::Matcher) }
  let(:matcher_b) { instance_double(Mutest::Matcher) }
  let(:subject_a) { instance_double(Mutest::Subject) }
  let(:subject_b) { instance_double(Mutest::Subject) }

  subject { object.call(env) }

  before do
    expect(Mutest::Matcher::Methods::Singleton).to receive(:new)
      .with(scope)
      .and_return(matcher_a)

    expect(Mutest::Matcher::Methods::Instance).to receive(:new)
      .with(scope)
      .and_return(matcher_b)

    expect(matcher_a).to receive(:call)
      .with(env)
      .and_return([subject_a])

    expect(matcher_b).to receive(:call)
      .with(env)
      .and_return([subject_b])
  end

  it 'concatenates subjects from matched singleton and instance methods' do
    should eql([subject_a, subject_b])
  end
end
