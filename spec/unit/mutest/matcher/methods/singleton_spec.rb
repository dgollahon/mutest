RSpec.describe Mutest::Matcher::Methods::Singleton, '#call' do
  let(:object) { described_class.new(class_under_test) }
  let(:env)    { Fixtures::TEST_ENV                    }

  let(:class_under_test) do
    parent = Module.new do
      def method_d
      end

      def method_e
      end
    end

    Class.new do
      extend parent

      def self.method_a
      end

      def self.method_b
      end
      class << self; protected :method_b; end

      def self.method_c
      end
      private_class_method :method_c
    end
  end

  let(:subject_a) { instance_double(Mutest::Subject, 'A') }
  let(:subject_b) { instance_double(Mutest::Subject, 'B') }
  let(:subject_c) { instance_double(Mutest::Subject, 'C') }

  let(:subjects) { [subject_a, subject_b, subject_c] }

  before do
    matcher = Mutest::Matcher::Method::Singleton

    {
      method_a: subject_a,
      method_b: subject_b,
      method_c: subject_c
    }.each do |method, subject|
      allow(matcher).to receive(:new)
        .with(class_under_test, class_under_test.method(method))
        .and_return(Mutest::Matcher::Static.new([subject]))
    end
  end

  it 'returns expected subjects' do
    expect(object.call(env)).to eql(subjects)
  end
end
