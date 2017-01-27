RSpec.describe Mutest::Reporter::CLI::Printer::MutationProgressResult do
  setup_shared_context

  let(:reportable) { mutation_a_result }

  before do
    allow(output).to receive(:tty?).and_return(true)
  end

  describe '.run' do
    context 'on killed mutest' do
      with(:mutation_a_test_result) { { passed: true } }

      it_reports Mutest::Color::RED.format('F')
    end

    context 'on alive mutest' do
      with(:mutation_a_test_result) { { passed: false } }

      it_reports Mutest::Color::GREEN.format('.')
    end
  end
end
