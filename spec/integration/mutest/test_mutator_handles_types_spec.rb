RSpec.describe 'AST type coverage', mutant: false do
  specify 'mutest should not crash for any node parser can generate' do
    Mutest::AST::Types::ALL.each do |type|
      Mutest::Mutator::REGISTRY.lookup(type)
    end
  end
end
