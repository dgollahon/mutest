RSpec.describe Mutest::Integration::Null do
  let(:object) { described_class.new(Mutest::Config::DEFAULT) }

  describe '#all_tests' do
    subject { object.all_tests }

    it { is_expected.to eql([]) }

    it_behaves_like 'an idempotent method'
  end

  describe '#call' do
    subject { object.call(tests) }

    let(:tests) { instance_double(Array) }

    it 'returns test result' do
      is_expected.to eql(
        Mutest::Result::Test.new(
          output:  '',
          passed:  true,
          runtime: 0.0,
          tests:   tests
        )
      )
    end
  end
end
