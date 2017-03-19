Mutest::Meta::Example.add :masgn do
  source 'a, b = c, d'

  singleton_mutations
  mutation 'a, b = nil'
  mutation 'a, b = self'
  mutation 'a, b = []'
  mutation 'a, b = [c]'
  mutation 'a, b = c, nil'
  mutation 'a, b = c, self'
  mutation 'a, b = [d]'
  mutation 'a, b = nil, d'
  mutation 'a, b = self, d'
end
