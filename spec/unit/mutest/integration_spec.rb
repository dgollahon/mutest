RSpec.describe Mutest::Integration do
  let(:class_under_test) do
    Class.new(described_class)
  end

  let(:object) { class_under_test.new(Mutest::Config::DEFAULT) }

  describe '#setup' do
    subject { object.setup }
    it_behaves_like 'a command method'
  end

  describe '.setup' do
    subject { described_class.setup(requirer, name) }

    let(:name)     { 'null'               }
    let(:requirer) { Mutest::Requirer.new }

    before do
      expect(requirer).to receive(:require)
        .with('mutest/integration/null')
    end

    it { is_expected.to be(Mutest::Integration::Null) }
  end
end
