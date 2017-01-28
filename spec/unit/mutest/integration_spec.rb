RSpec.describe Mutest::Integration do
  let(:class_under_test) do
    Class.new(described_class)
  end

  let(:object) { class_under_test.new(Mutest::Config::DEFAULT) }

  describe '#setup' do
    subject { object.setup }
    it_should_behave_like 'a command method'
  end

  describe '.setup' do
    subject { described_class.setup(kernel, name) }

    let(:name)   { 'null'               }
    let(:kernel) { class_double(Kernel) }

    before do
      expect(kernel).to receive(:require)
        .with('mutest/integration/null')
    end

    it { is_expected.to be(Mutest::Integration::Null) }
  end
end

RSpec.describe Mutest::Integration::Null do
  let(:object) { described_class.new(Mutest::Config::DEFAULT) }

  describe '#all_tests' do
    subject { object.all_tests }

    it { is_expected.to eql([]) }

    it_should_behave_like 'an idempotent method'
  end

  describe '#call' do
    let(:tests) { instance_double(Array) }

    subject { object.call(tests) }

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
