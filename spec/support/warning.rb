require 'yaml'
require 'equalizer'
require 'memoizable'
require 'ice_nine'

module MutestSpec
  class Warning
    # Install our $stderr warning proxy only if the top level program is RSpec
    #
    # Mutest performs certain mutations which emit warnings that will obviously
    # not be on our whitelist. We don't need to have enforce our warning assertions
    # then anyways
    def self.hook_under_rspec
      $stderr = EXTRACTOR if $PROGRAM_NAME.end_with?('/rspec')
    end

    def self.assert_no_warnings
      return if EXTRACTOR.warnings.empty?

      raise UnexpectedWarnings, EXTRACTOR.warnings.to_a
    end

    class UnexpectedWarnings < StandardError
      MSG = 'Unexpected warnings: %s'.freeze

      def initialize(warnings)
        super(MSG % warnings.join("\n"))
      end
    end

    class Extractor < DelegateClass(IO)
      PATTERN = /\A(?:.+):(?:\d+): warning: (?:.+)\n\z/.freeze

      include Memoizable
      include Equalizer.new(:whitelist, :seen, :io)

      def initialize(io, whitelist)
        @whitelist = whitelist
        @seen      = Set.new
        @io        = io

        super(io)
      end

      def write(message)
        return super if PATTERN !~ message

        add(message.chomp)

        self
      end

      def warnings
        seen.dup
      end
      memoize :warnings

      private

      def add(warning)
        return if whitelist.any?(&warning.public_method(:end_with?))

        seen << warning
      end

      attr_reader :whitelist, :seen, :io
    end

    warnings  = Pathname.new(__dir__).join('warnings.yml').freeze
    whitelist = IceNine.deep_freeze(YAML.safe_load(warnings.read))

    EXTRACTOR = Extractor.new(STDERR, whitelist)
  end
end
