Mutest::Meta::Example.add :splat do
  source 'foo(*bar)'

  singleton_mutations
  mutation 'foo'
  mutation 'foo(nil)'
  mutation 'foo(*nil)'
  mutation 'foo(bar)'
  mutation 'foo(self)'
  mutation 'foo(*self)'
end

Mutest::Meta::Example.add :splat do
  source 'a = *bar'

  singleton_mutations
  mutation 'a__mutest__ = *bar'
  mutation 'a = nil'
  mutation 'a = self'
  mutation 'a = []'
  mutation 'a = [nil]'
  mutation 'a = [*nil]'
  mutation 'a = [self]'
  mutation 'a = [*self]'
  mutation 'a = [bar]'
  mutation s(:lvasgn, :a, s(:splat, s(:send, nil, :bar)))
end
