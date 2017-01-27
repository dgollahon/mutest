Mutest::Meta::Example.add :super do
  source 'super'

  singleton_mutations
  mutation 'super()'
end

Mutest::Meta::Example.add :super do
  source 'super()'

  singleton_mutations
end

Mutest::Meta::Example.add :super do
  source 'super(foo, bar)'

  singleton_mutations
  mutation 'super()'
  mutation 'super(foo)'
  mutation 'super(bar)'
  mutation 'super(foo, nil)'
  mutation 'super(foo, self)'
  mutation 'super(nil, bar)'
  mutation 'super(self, bar)'
end
