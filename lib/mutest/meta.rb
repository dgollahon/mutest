module Mutest
  # Namespace for mutest metadata
  module Meta
    require 'mutest/meta/example'
    require 'mutest/meta/example/dsl'
    require 'mutest/meta/example/verification'

    # Mutation example
    class Example

      # rubocop:disable MutableConstant
      ALL = []

      # Add example
      #
      # @return [undefined]
      def self.add(type, &block)
        file = caller.first.split(':in', 2).first
        ALL << DSL.call(file, type, block)
      end

      Pathname.glob(Pathname.new(__dir__).parent.parent.join('meta', '*.rb'))
        .sort
        .each(&method(:require))

      ALL.freeze

      # Remove mutation method only present for DSL executions from meta/**/*.rb
      class << self
        undef_method :add
      end

    end # Example
  end # Meta
end # Mutest
