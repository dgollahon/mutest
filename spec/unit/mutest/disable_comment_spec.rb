module Mutest
  class DisableComment
    include Concord.new(:original, :mutation)

    PATTERN = /\A# *mutest:disable (?<original>.+)~>(?<mutation>.+)\z/

    def self.parse(comment)
      match = comment.match(PATTERN)
      original_source, mutation_source = match[:original], match[:mutation]
      original = ::Parser::CurrentRuby.parse(original_source)
      mutation = ::Parser::CurrentRuby.parse(mutation_source)

      new(original, mutation)
    end

    def disables?(from, to)
      ContextFreeNode.new(original) == from &&
        ContextFreeNode.new(mutation) == to
    end

    class ContextFreeNode
      include Concord.new(:node), AST::Sexp

      def ==(other)
        if meta.bareword? || no_child_nodes?
          node == other || as_lvar == other
        else
          other == matchable_node
        end
      end

      private

      def no_child_nodes?
        node.children.none? { |child| child.instance_of?(::Parser::AST::Node) }
      end

      def matchable_node
        children =
          node.to_a.map do |child|
            child.instance_of?(::Parser::AST::Node) ? self.class.new(child) : child
          end

        s(node.type, *children)
      end

      def as_lvar
        s(:lvar, meta.selector)
      end

      def meta
        Mutest::AST::Meta::Send.new(node)
      end
    end
  end
end

RSpec.describe Mutest::DisableComment do
  subject(:disable_comment) do
    described_class.parse('# mutest:disable foo.to_h ~> foo.to_hash')
  end

  it 'parses comments' do
    expect(disable_comment).to eql(
      described_class.new(
        s(:send, s(:send, nil, :foo), :to_h),
        s(:send, s(:send, nil, :foo), :to_hash)
      )
    )
  end

  it 'disables foo().to_h -> foo().to_hash' do
    original = Parser::CurrentRuby.parse('foo.to_h')
    mutation = Parser::CurrentRuby.parse('foo.to_hash')

    expect(disable_comment.disables?(original, mutation)).to be(true)
  end

  fit 'disables (send (lvar foo) :to_h) -> (send (lvar foo) :to_hash)' do
    original = Parser::CurrentRuby.parse('foo = nil; foo.to_h').to_a.last
    mutation = Parser::CurrentRuby.parse('foo = nil; foo.to_hash').to_a.last

    expect(disable_comment.disables?(original, mutation)).to be(true)
  end

  it 'does not disable bar.to_h -> bar.to_hash' do
    original = Parser::CurrentRuby.parse('bar.to_h')
    mutation = Parser::CurrentRuby.parse('bar.to_hash')

    expect(disable_comment.disables?(original, mutation)).to be(false)
  end
end
