RSpec.describe Mutest::AST::Meta::Send do
  let(:object) { described_class.new(node) }

  def parse(source)
    Parser::CurrentRuby.parse(source)
  end

  let(:method_call)            { parse('foo.bar(baz)')             }
  let(:attribute_read)         { parse('foo.bar')                  }
  let(:attribute_assignment)   { parse('foo.bar = baz')            }
  let(:binary_method_operator) { parse('foo == bar')               }
  let(:method_method_call)     { parse('foo.method(:bar)')         }
  let(:public_method_call)     { parse("foo.public_method('bar')") }

  class Expectation
    include Anima.new(
      :name,
      :attribute_assignment,
      :binary_method_operator,
      :method_object_selector
    )
    include Adamantium

    ALL = [
      [:method_call,            false, false, false],
      [:attribute_read,         false, false, false],
      [:attribute_assignment,   true,  false, false],
      [:binary_method_operator, false, true,  false],
      [:method_method_call,     false, false,  true],
      [:public_method_call,     false, false,  true]
    ].map do |values|
      new(Hash[anima.attribute_names.zip(values)])
    end.freeze
  end

  # Rspec should have a build in for this kind of "n-dimensional assertion with context"
  (Expectation.anima.attribute_names - %i[name]).each do |name|
    describe "##{name}?" do
      subject { object.public_send(:"#{name}?") }

      Expectation::ALL.each do |expectation|
        context "on #{expectation.name}" do
          let(:node) { public_send(expectation.name) }

          it { is_expected.to be(expectation.public_send(name)) }
        end
      end
    end
  end
end
