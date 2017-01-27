Mutest::Meta::Example.add :gvasgn do
  source '$a = true'

  singleton_mutations
  mutation '$a__mutest__ = true'
  mutation '$a = false'
  mutation '$a = nil'
end
