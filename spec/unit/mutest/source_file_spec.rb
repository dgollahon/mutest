RSpec.describe Mutest::SourceFile do
  subject(:source_file) { described_class.read(path) }

  let(:ast)  { Parser::CurrentRuby.parse(source)       }
  let(:path) { instance_double(Pathname, read: source) }

  let(:source) do
    <<-RUBY
    # rubocop:disable
    def foo(bar)
    end

    # mutest:disable
    def bar
    end
    RUBY
  end

  it 'exposes the AST' do
    expect(source_file.ast).to eql(ast)
  end

  it 'exposes the path' do
    expect(source_file.path).to be(path)
  end

  it 'ignores the line after the the comment' do
    foo_method, bar_method = *ast

    aggregate_failures do
      expect(source_file.ignore?(foo_method)).to be(false)
      expect(source_file.ignore?(bar_method)).to be(true)
    end
  end

  it 'ignores nodes that do not have a location' do
    _, bar_method = *ast
    _, bar_method_args, = *bar_method

    expect(source_file.ignore?(bar_method_args)).to be(false)
  end
end
