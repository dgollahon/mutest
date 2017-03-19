Mutest::Meta::Example.add :lvasgn do
  source 'a = true'

  singleton_mutations
  mutation 'a__mutest__ = true'
  mutation 'a = false'
end
