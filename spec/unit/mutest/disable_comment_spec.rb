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
      ContextFreeNode.new(original) == from && ContextFreeNode.new(mutation) == to
    end

    class ContextFreeNode
      include Concord.new(:node), AST::Sexp

      def ==(other)
        if meta.bareword?
          node.eql?(other) || as_lvar.eql?(other)
        else
          other == wildcard_node
        end
      end

      private

      def wildcard_node
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
        AST::Meta::Send.new(node)
      end
    end
  end
end

RSpec.describe Mutest::DisableComment do
  subject(:disable_comment) do
    described_class.parse('# mutest:disable foo.to_h ~> foo.to_hash')
  end

  def parse(source)
    Parser::CurrentRuby.parse(source)
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
    original = parse('foo.to_h')
    mutation = parse('foo.to_hash')

    expect(disable_comment.disables?(original, mutation)).to be(true)
  end

  it 'disables (send (lvar foo) :to_h) -> (send (lvar foo) :to_hash)' do
    original = parse('foo = nil; foo.to_h').to_a.last
    mutation = parse('foo = nil; foo.to_hash').to_a.last

    expect(disable_comment.disables?(original, mutation)).to be(true)
  end

  it 'does not disable bar.to_h -> bar.to_hash' do
    original = parse('bar.to_h')
    mutation = parse('bar.to_hash')

    expect(disable_comment.disables?(original, mutation)).to be(false)
  end

  it 'does not disable foo.to_h -> foo' do
    original = parse('foo = nil; foo.to_h').to_a.last
    mutation = parse('foo = nil; foo').to_a.last

    expect(disable_comment.disables?(original, mutation)).to be(false)
  end

  it 'does not disable foo.to_h -> foo.to_a' do
    original = parse('foo = nil; foo.to_h').to_a.last
    mutation = parse('foo = nil; foo.to_a').to_a.last

    expect(disable_comment.disables?(original, mutation)).to be(false)
  end

  it 'does not disable foo.wrong -> foo.to_hash' do
    original = parse('foo = nil; foo.wrong').to_a.last
    mutation = parse('foo = nil; foo.to_hash').to_a.last

    expect(disable_comment.disables?(original, mutation)).to be(false)
  end
end
