RSpec.describe Mutest::Ignores do
  subject(:comments) { described_class.new(parsed.last) }

  let(:ast) { parsed.first }

  let(:parsed) do
    Parser::CurrentRuby.parse_with_comments(<<-RUBY)
    # rubocop:disable
    def foo(bar)
    end

    # mutest:disable
    def bar
    end
    RUBY
  end

  it 'ignores the line after the the comment' do
    foo_method, bar_method = *ast

    aggregate_failures do
      expect(comments.ignored?(foo_method)).to be(false)
      expect(comments.ignored?(bar_method)).to be(true)
    end
  end

  it 'ignores nodes that do not have a location' do
    _, bar_method = *ast
    _, bar_method_args, = *bar_method

    expect(comments.ignored?(bar_method_args)).to be(false)
  end
end
