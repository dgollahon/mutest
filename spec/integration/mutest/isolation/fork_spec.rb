RSpec.describe Mutest::Isolation::Fork, mutest: false do
  specify do
    a = 1
    expect do
      Mutest::Config::DEFAULT.isolation.call { a = 2 }
    end.to_not change { a }
  end
end
