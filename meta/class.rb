Mutest::Meta::Example.add :class do
  source 'class Foo; bar; end'

  mutation 'class Foo; nil; end'
  mutation 'class Foo; self; end'
end

Mutest::Meta::Example.add :class do
  source 'class Foo; end'
end
