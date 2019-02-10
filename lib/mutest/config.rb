module Mutest
  # Standalone configuration of a mutest execution.
  #
  # Does not reference any "external" volatile state. The configuration applied
  # to current environment is being represented by the Mutest::Env object.
  class Config
    include Anima.new(
      :expression_parser,
      :fail_fast,
      :integration,
      :includes,
      :isolation,
      :jobs,
      :kernel,
      :load_path,
      :matcher,
      :open3,
      :pathname,
      :requirer,
      :requires,
      :reporter,
      :zombie
    )
    include Adamantium::Flat

    %i[fail_fast zombie].each do |name|
      define_method(:"#{name}?") { public_send(name) }
    end
  end
end
