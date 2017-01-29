Mutest::Meta::Example.add :restarg do
  source 'def foo(*bar); end'

  mutation 'def foo; end'
  mutation 'def foo(*_bar); end'
  mutation 'def foo(*bar); bar = []; end'
  mutation 'def foo(*bar); raise; end'
  mutation 'def foo(*bar); super; end'
end
