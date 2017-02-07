Mutest::Meta::Example.add :array do
  source '[true]'

  singleton_mutations
  mutation 'true'
  mutation '[false]'
  mutation '[]'
end

Mutest::Meta::Example.add :array do
  source '[true, false]'

  singleton_mutations

  # Mutation of each element in array
  mutation '[false, false]'
  mutation '[true, true]'

  # Remove each element of array once
  mutation '[true]'
  mutation '[false]'

  # Empty array
  mutation '[]'
end
