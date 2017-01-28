RSpec.describe Mutest::Env do
  context '#kill' do
    subject { object.kill(mutation) }

    let(:object) do
      described_class.new(
        actor_env:        Mutest::Actor::Env.new(Thread),
        config:           config,
        integration:      integration,
        matchable_scopes: [],
        mutations:        [],
        selector:         selector,
        subjects:         [],
        parser:           Mutest::Parser.new
      )
    end

    let(:integration)       { instance_double(Mutest::Integration)     }
    let(:test_a)            { instance_double(Mutest::Test)            }
    let(:test_b)            { instance_double(Mutest::Test)            }
    let(:tests)             { [test_a, test_b]                         }
    let(:selector)          { instance_double(Mutest::Selector)        }
    let(:integration_class) { Mutest::Integration::Null                }
    let(:isolation)         { instance_double(Mutest::Isolation::Fork) }
    let(:mutation_subject)  { instance_double(Mutest::Subject)         }

    let(:mutation) do
      instance_double(
        Mutest::Mutation,
        subject: mutation_subject
      )
    end

    let(:config) do
      Mutest::Config::DEFAULT.with(
        isolation:   isolation,
        integration: integration_class,
        kernel:      class_double(Kernel)
      )
    end

    shared_examples_for 'mutation kill' do
      specify do
        is_expected.to eql(
          Mutest::Result::Mutation.new(
            mutation:    mutation,
            test_result: test_result
          )
        )
      end
    end

    before do
      expect(selector).to receive(:call)
        .with(mutation_subject)
        .and_return(tests)

      allow(Time).to receive_messages(now: Time.at(0))
    end

    context 'when isolation does not raise error' do
      let(:test_result) { instance_double(Mutest::Result::Test) }

      before do
        expect(isolation).to receive(:call)
          .ordered
          .and_yield

        expect(mutation).to receive(:insert)
          .ordered
          .with(config.kernel)

        expect(integration).to receive(:call)
          .ordered
          .with(tests)
          .and_return(test_result)
      end

      include_examples 'mutation kill'
    end

    context 'when isolation does raise error' do
      before do
        expect(isolation).to receive(:call)
          .and_raise(Mutest::Isolation::Error, 'test-error')
      end

      let(:test_result) do
        Mutest::Result::Test.new(
          output:  'test-error',
          passed:  false,
          runtime: 0.0,
          tests:   tests
        )
      end

      include_examples 'mutation kill'
    end
  end
end
