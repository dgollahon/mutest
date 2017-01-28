RSpec.describe Mutest::Matcher::Compiler::SubjectPrefix, '#call' do
  let(:object)   { described_class.new(parse_expression('Foo*')) }

  let(:_subject) do
    instance_double(
      Mutest::Subject,
      expression: parse_expression(subject_expression)
    )
  end

  subject { object.call(_subject) }

  context 'when subject expression is prefixed by expression' do
    let(:subject_expression) { 'Foo::Bar' }

    it { is_expected.to be(true) }
  end

  context 'when subject expression is NOT prefixed by expression' do
    let(:subject_expression) { 'Bar' }

    it { is_expected.to be(false) }
  end
end
