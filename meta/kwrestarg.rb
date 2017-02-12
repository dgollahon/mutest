Mutest::Meta::Example.add :kwrestarg do
  source 'def foo(**bar); end'

  mutation 'def foo; end'
  mutation 'def foo(**bar); bar = {}; end'
  mutation 'def foo(**_bar); end'
  mutation 'def foo(**bar); raise; end'
  mutation 'def foo(**bar); super; end'
end

Mutest::Meta::Example.add :kwrestarg do
  source 'def foo(**_bar); end'

  mutation 'def foo; end'
  mutation 'def foo(**_bar); raise; end'
  mutation 'def foo(**_bar); super; end'
end

Mutest::Meta::Example.add :kwrestarg do
  source 'def foo(**); end'

  mutation 'def foo; end'
  mutation 'def foo(**); raise; end'
  mutation 'def foo(**); super; end'
end
