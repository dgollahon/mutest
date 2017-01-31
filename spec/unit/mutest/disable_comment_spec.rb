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
      original == from && mutation == to
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

  it 'disables (send (lvar foo) :to_h) -> (send (lvar foo) :to_hash)' do
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
