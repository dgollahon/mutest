desc 'Run mutest on itself'
namespace :metrics do
  task :mutest do
    arguments = %w[
      bundle exec mutest
      --include lib
      --since HEAD~1
      --require mutest
      --use rspec
      --zombie
    ]
    arguments.concat(%w[--jobs 4]) if ENV.key?('CIRCLECI')

    arguments.concat(%w[-- Mutest*])

    Kernel.system(*arguments) or fail 'Mutest task is not successful'
  end
end
