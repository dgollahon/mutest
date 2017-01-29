RSpec.describe Mutest::Isolation::Fork, mutant: false do
  specify do
    a = 1
    expect do
      Mutest::Config::DEFAULT.isolation.call { a = 2 }
    end.not_to change { a }
  end
end
