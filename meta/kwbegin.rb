Mutest::Meta::Example.add :kwbegin do
  source 'begin; true; end'

  singleton_mutations
  mutation 'begin; false; end'
end
