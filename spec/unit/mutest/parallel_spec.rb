RSpec.describe Mutest::Parallel do
  describe '.async' do
    subject { described_class.async(config) }

    let(:config)  { instance_double(Mutest::Parallel::Config, env: env)       }
    let(:env)     { instance_double(Mutest::Actor::Env, new_mailbox: mailbox) }
    let(:mailbox) { Mutest::Actor::Mailbox.new                                }
    let(:master)  { instance_double(Mutest::Parallel::Master)                 }

    before do
      expect(described_class::Master).to receive(:call).with(config).and_return(master)
    end

    it { should eql(described_class::Driver.new(mailbox.bind(master))) }
  end
end
