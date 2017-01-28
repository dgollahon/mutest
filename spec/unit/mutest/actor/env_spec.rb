RSpec.describe Mutest::Actor::Env do
  let(:thread)      { instance_double(Thread) }
  let(:thread_root) { class_double(Thread)    }

  let(:object) { described_class.new(thread_root) }

  describe '#spawn' do
    subject { object.spawn(&block) }

    let!(:mailbox) { Mutest::Actor::Mailbox.new }

    let(:yields) { [] }

    let(:block) { ->(actor) { yields << actor } }

    before do
      expect(Mutest::Actor::Mailbox).to receive(:new).and_return(mailbox).ordered
      expect(thread_root).to receive(:new).and_yield.and_return(thread).ordered
    end

    it 'returns sender' do
      is_expected.to be(mailbox.sender)
    end

    it 'yields actor' do
      expect { subject }.to change { yields }.from([]).to([mailbox])
    end
  end
end
