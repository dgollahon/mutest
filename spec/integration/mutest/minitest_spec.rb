# frozen_string_literal: true

RSpec.describe 'minitest integration', mutest: false do
  let(:base_cmd) { 'bundle exec mutest -I test -I lib --require test_app --use minitest' }

  let(:gemfile) { 'Gemfile.minitest' }

  it_behaves_like 'framework integration'
end
