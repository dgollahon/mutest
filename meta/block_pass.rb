Mutest::Meta::Example.add :block_pass do
  source 'foo(&method(:bar))'

  singleton_mutations
  mutation 'foo'
  mutation 'foo(&nil)'
  mutation 'foo(&self)'
  mutation 'foo(&method)'
  mutation 'foo(&method(nil))'
  mutation 'foo(&method(self))'
  mutation 'foo(&method(:bar__mutest__))'
  mutation 'foo(&public_method(:bar))'
  mutation 'foo(&:bar)'
end

Mutest::Meta::Example.add :block_pass do
  source 'foo(&:to_s)'

  singleton_mutations
  mutation 'foo'
  mutation 'foo(&nil)'
  mutation 'foo(&self)'
  mutation 'foo(&:to_s__mutest__)'
  mutation 'foo(&:to_str)'
end

Mutest::Meta::Example.add :block_pass do
  source 'foo(&:bar)'

  singleton_mutations
  mutation 'foo'
  mutation 'foo(&nil)'
  mutation 'foo(&self)'
  mutation 'foo(&:bar__mutest__)'
end
