# frozen_string_literal: true

Mutest::Meta::Example.add :indexasgn do
  source 'foo[bar] = baz'

  singleton_mutations
  mutation 'self[bar] = baz'
  mutation 'foo'
  mutation 'foo[bar]'
  mutation 'foo.at(bar)'
  mutation 'foo.fetch(bar)'
  mutation 'foo.key?(bar)'
  mutation 'foo[bar] = self'
  mutation 'foo[bar] = nil'
  mutation 'foo[nil] = baz'
  mutation 'foo[self] = baz'
  mutation 'foo[] = baz'
  mutation 'baz'
  mutation 'bar'
end

Mutest::Meta::Example.add :indexasgn do
  source 'self[foo] += bar'

  singleton_mutations
  mutation 'self[] += bar'
  mutation 'self[nil] += bar'
  mutation 'self[self] += bar'
  mutation 'self[foo] += nil'
  mutation 'self[foo] += self'
end

Mutest::Meta::Example.add :op_asgn do
  source 'self[foo] += bar'

  singleton_mutations
  mutation 'self[] += bar'
  mutation 'self[nil] += bar'
  mutation 'self[self] += bar'
  mutation 'self[foo] += nil'
  mutation 'self[foo] += self'
end
