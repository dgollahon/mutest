Mutest::Meta::Example.add :return do
  source 'return'

  singleton_mutations
end

Mutest::Meta::Example.add :return do
  source 'return foo'

  singleton_mutations
  mutation 'foo'
  mutation 'return nil'
  mutation 'return self'
end
