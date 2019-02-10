# frozen_string_literal: true

Mutest::Meta::Example.add :block do
  source '->() {}'

  singleton_mutations

  mutation '->() { raise }'
end

Mutest::Meta::Example.add :lambda do
  source '->() {}'

  singleton_mutations

  mutation '->() { raise }'
end
