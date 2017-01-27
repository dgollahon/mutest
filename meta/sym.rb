Mutest::Meta::Example.add :sym do
  source ':foo'

  singleton_mutations
  mutation ':foo__mutest__'
end
