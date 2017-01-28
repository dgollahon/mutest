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
