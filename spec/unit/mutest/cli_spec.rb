RSpec.describe Mutest::CLI do
  let(:object) { described_class }

  shared_examples_for 'an invalid cli run' do
    it 'raises error' do
      expect do
        subject
      end.to raise_error(Mutest::CLI::Error, expected_message)
    end
  end

  shared_examples_for 'a cli parser' do
    it { expect(subject.config.integration).to eql(expected_integration) }
    it { expect(subject.config.reporter).to eql(expected_reporter)       }
    it { expect(subject.config.matcher).to eql(expected_matcher_config)  }
  end

  describe '.run' do
    subject { object.run(arguments) }

    let(:arguments) { instance_double(Array)                                         }
    let(:report)    { instance_double(Mutest::Result::Env, success?: report_success) }
    let(:config)    { instance_double(Mutest::Config)                                }
    let(:env)       { instance_double(Mutest::Env)                                   }

    before do
      expect(described_class).to receive(:call).with(arguments).and_return(config)
      expect(Mutest::Env::Bootstrap).to receive(:call).with(config).and_return(env)
      expect(Mutest::Runner).to receive(:call).with(env).and_return(report)
    end

    context 'when report signals success' do
      let(:report_success) { true }

      it 'exits failure' do
        expect(subject).to be(true)
      end
    end

    context 'when report signals error' do
      let(:report_success) { false }

      it 'exits failure' do
        expect(subject).to be(false)
      end
    end

    context 'when execution raises an Mutest::CLI::Error' do
      let(:exception) { Mutest::CLI::Error.new('test-error') }
      let(:report_success) { nil }

      before do
        expect(report).to receive(:success?).and_raise(exception)
      end

      it 'exits failure' do
        expect($stderr).to receive(:puts).with('test-error')
        expect(subject).to be(false)
      end
    end
  end

  describe '.new' do
    subject { object.new(arguments) }

    let(:object) { described_class }

    # Defaults
    let(:expected_integration)    { Mutest::Integration::Null        }
    let(:expected_reporter)       { Mutest::Config::DEFAULT.reporter }
    let(:expected_matcher_config) { default_matcher_config           }

    let(:default_matcher_config) do
      Mutest::Matcher::Config::DEFAULT
        .with(match_expressions: expressions.map(&method(:parse_expression)))
    end

    let(:flags)       { []           }
    let(:expressions) { %w[TestApp*] }

    let(:arguments) { flags + expressions }

    context 'with unknown flag' do
      let(:flags) { %w[--invalid] }

      let(:expected_message) { 'invalid option: --invalid' }

      it_behaves_like 'an invalid cli run'
    end

    context 'with unknown option' do
      let(:flags) { %w[--invalid Foo] }

      let(:expected_message) { 'invalid option: --invalid' }

      it_behaves_like 'an invalid cli run'
    end

    context 'with include help flag' do
      let(:flags) { %w[--help] }

      before do
        expect($stdout).to receive(:puts).with(expected_message)
        expect(Kernel).to receive(:exit)
      end

      it_behaves_like 'a cli parser'

      let(:expected_message) do
        <<~MESSAGE
          usage: mutest [options] MATCH_EXPRESSION ...
          Environment:
                  --zombie                     Run mutest zombified
              -I, --include DIRECTORY          Add DIRECTORY to $LOAD_PATH
              -r, --require NAME               Require file with NAME
              -j, --jobs NUMBER                Number of kill jobs. Defaults to number of processors.

          Options:
                  --use INTEGRATION            Use INTEGRATION to kill mutations
                  --ignore-subject EXPRESSION  Ignore subjects that match EXPRESSION as prefix
                  --since REVISION             Only select subjects touched since REVISION
                  --fail-fast                  Fail fast
                  --version                    Print mutests version
              -h, --help                       Show this message
        MESSAGE
      end
    end

    context 'with include flag' do
      let(:flags) { %w[--include foo] }

      it_behaves_like 'a cli parser'

      it 'configures includes' do
        expect(subject.config.includes).to eql(%w[foo])
      end
    end

    context 'with use flag' do
      context 'when using the existing integration with rspec' do
        let(:flags) { %w[--use rspec] }
        let(:expected_integration) { Mutest::Integration::Rspec }

        before do
          expect(Mutest::Config::DEFAULT.requirer).to receive(:require)
            .with('mutest/integration/rspec')
            .and_call_original
        end

        it_behaves_like 'a cli parser'
      end

      context 'when specifying the default null integration explicitely' do
        let(:flags) { %w[--use null] }
        let(:expected_integration) { Mutest::Integration::Null }

        before do
          expect(Mutest::Config::DEFAULT.requirer).to receive(:require)
            .with('mutest/integration/null')
            .and_call_original
        end

        it_behaves_like 'a cli parser'
      end

      context 'when integration does NOT exist' do
        let(:flags) { %w[--use other] }

        it 'raises error' do
          expect { subject }.to raise_error(
            Mutest::CLI::Error,
            'Could not load integration "other" (you may want to try installing the gem mutest-other)'
          )
        end
      end
    end

    context 'with version flag' do
      let(:flags) { %w[--version] }

      before do
        expect(Kernel).to receive(:exit)
        expect($stdout).to receive(:puts).with("mutest-#{Mutest::VERSION}")
      end

      it_behaves_like 'a cli parser'
    end

    context 'with jobs flag' do
      let(:flags) { %w[--jobs 0] }

      it_behaves_like 'a cli parser'

      it 'configures expected coverage' do
        expect(subject.config.jobs).to be(0)
      end
    end

    context 'with require flags' do
      let(:flags) { %w[--require foo --require bar] }

      it_behaves_like 'a cli parser'

      it 'configures requires' do
        expect(subject.config.requires).to eql(%w[foo bar])
      end
    end

    context 'with --since flag' do
      let(:flags) { %w[--since master] }

      let(:expected_matcher_config) do
        default_matcher_config.with(
          subject_filters: [
            Mutest::Repository::SubjectFilter.new(
              Mutest::Repository::Diff.new(
                config: Mutest::Config::DEFAULT,
                from:   'HEAD',
                to:     'master'
              )
            )
          ]
        )
      end

      it_behaves_like 'a cli parser'
    end

    context 'with subject-ignore flag' do
      let(:flags) { %w[--ignore-subject Foo::Bar] }

      let(:expected_matcher_config) do
        default_matcher_config.with(ignore_expressions: [parse_expression('Foo::Bar')])
      end

      it_behaves_like 'a cli parser'
    end

    context 'with fail-fast flag' do
      let(:flags) { %w[--fail-fast] }

      it_behaves_like 'a cli parser'

      it 'sets the fail fast option' do
        expect(subject.config.fail_fast).to be(true)
      end
    end

    context 'with zombie flag' do
      let(:flags) { %w[--zombie] }

      it_behaves_like 'a cli parser'

      it 'sets the zombie option' do
        expect(subject.config.zombie).to be(true)
      end
    end
  end
end
