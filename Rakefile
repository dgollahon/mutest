require 'devtools'

Devtools.init_rake_tasks

Rake.application.load_imports

task('metrics:mutant').clear
namespace :metrics do
  task mutant: :coverage do
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

    Kernel.system(*arguments) or fail 'Mutant task is not successful'
  end
end
