Mutest::Meta::Example.add :yield do
  source 'yield true'

  singleton_mutations
  mutation 'yield false'
  mutation 'yield'
end
