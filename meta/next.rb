Mutest::Meta::Example.add :next do
  source 'next true'

  singleton_mutations
  mutation 'next false'
  mutation 'next'
  mutation 'break true'
end
