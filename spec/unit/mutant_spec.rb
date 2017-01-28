RSpec.describe Mutest do
  let(:object) { described_class }

  describe '.ci?' do
    subject { object.ci? }

    let(:value) { instance_double(Object, 'value') }

    before do
      expect(ENV).to receive(:key?).with('CI').and_return(value)
    end

    it { is_expected.to be(value) }
  end
end
