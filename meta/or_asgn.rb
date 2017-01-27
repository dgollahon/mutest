Mutest::Meta::Example.add :or_asgn do
  source 'a ||= 1'

  singleton_mutations
  mutation 'a__mutest__ ||= 1'
  mutation 'a ||= nil'
  mutation 'a ||= self'
  mutation 'a ||= 0'
  mutation 'a ||= -1'
  mutation 'a ||= 2'
end

Mutest::Meta::Example.add :or_asgn do
  source '@a ||= 1'

  singleton_mutations
  mutation '@a ||= nil'
  mutation '@a ||= self'
  mutation '@a ||= 0'
  mutation '@a ||= -1'
  mutation '@a ||= 2'
end

Mutest::Meta::Example.add :or_asgn do
  source 'Foo ||= nil'

  singleton_mutations
end

Mutest::Meta::Example.add :or_asgn do
  source '@a ||= self.bar'

  singleton_mutations
  mutation '@a ||= nil'
  mutation '@a ||= self'
  mutation '@a ||= bar'
end

Mutest::Meta::Example.add :or_asgn do
  source 'foo[:bar] ||= 1'

  singleton_mutations
  mutation 'foo[:bar] ||= nil'
  mutation 'foo[:bar] ||= self'
  mutation 'foo[:bar] ||= 0'
  mutation 'foo[:bar] ||= -1'
  mutation 'foo[:bar] ||= 2'
end
