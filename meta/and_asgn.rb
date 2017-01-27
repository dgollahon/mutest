Mutest::Meta::Example.add :and_asgn do
  source 'a &&= 1'

  singleton_mutations

  mutation 'a__mutest__ &&= 1'
  mutation 'a &&= nil'
  mutation 'a &&= 0'
  mutation 'a &&= -1'
  mutation 'a &&= 2'
  mutation 'a &&= self'
end
