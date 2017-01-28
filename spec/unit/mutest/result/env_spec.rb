RSpec.describe Mutest::Result::Env do
  let(:object) do
    described_class.new(
      runtime:         instance_double(Float),
      env:             env,
      subject_results: [subject_result]
    )
  end

  let(:env) do
    instance_double(
      Mutest::Env,
      subjects:  [instance_double(Mutest::Subject)],
      mutations: [instance_double(Mutest::Mutation)]
    )
  end

  let(:subject_result) do
    instance_double(
      Mutest::Result::Subject,
      amount_mutation_results: results,
      amount_mutations_killed: killed,
      success?:                true
    )
  end

  let(:results) { 1 }
  let(:killed)  { 0 }

  describe '#success?' do
    subject { object.success? }

    context 'when coverage matches expectation' do
      let(:killed) { 1 }

      it { is_expected.to be(true) }
    end

    context 'when coverage does not match expectation' do
      it { is_expected.to be(false) }
    end
  end

  describe '#failed_subject_results' do
    subject { object.failed_subject_results }

    it { is_expected.to eql([]) }
  end

  describe '#coverage' do
    subject { object.coverage }

    context 'when there are no results' do
      let(:results) { 0 }

      it { is_expected.to eql(Rational(1)) }
    end

    context 'when there are no kills' do
      it { is_expected.to eql(Rational(0)) }
    end

    context 'when there are kills' do
      let(:killed)  { 1 }
      let(:results) { 2 }

      it { is_expected.to eql(Rational(1, 2)) }
    end
  end

  describe '#amount_mutations' do
    subject { object.amount_mutations }

    it { is_expected.to be(1) }
  end

  describe '#amount_subjects' do
    subject { object.amount_subjects }

    it { is_expected.to be(1) }
  end
end
