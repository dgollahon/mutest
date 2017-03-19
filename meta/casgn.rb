Mutest::Meta::Example.add :casgn do
  source 'A = true'

  mutation 'A__MUTEST__ = true'
  mutation 'A = false'
  mutation 'remove_const :A'
end

Mutest::Meta::Example.add :casgn do
  source 'self::A = true'

  mutation 'self::A__MUTEST__ = true'
  mutation 'self::A = false'
  mutation 'self.remove_const :A'
end

Mutest::Meta::Example.add :casgn do
  source 'A &&= true'

  singleton_mutations
  mutation 'A__MUTEST__ &&= true'
  mutation 'A &&= false'
end
