Mutest::Meta::Example.add :cvasgn do
  source '@@a = true'

  singleton_mutations
  mutation '@@a__mutest__ = true'
  mutation '@@a = false'
end
