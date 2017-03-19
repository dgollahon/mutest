Mutest::Meta::Example.add :str do
  source '"foo"'

  singleton_mutations
  mutation '"foo__mutest__"'
end
