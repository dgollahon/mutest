RSpec.shared_examples_for 'an idempotent method' do
  it 'is idempotent' do
    first = subject
    raise 'RSpec not configured for threadsafety' unless RSpec.configuration.threadsafe?

    mutex = __memoized.instance_variable_get(:@mutex)
    memoized = __memoized.instance_variable_get(:@memoized)
    mutex.synchronize { memoized.delete(:subject) }
    expect(subject).to equal(first)
  end
end
