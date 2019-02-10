module Mutest
  class Reporter
    class CLI
      class Printer
        # Printer for mutation config
        class Config < self
          # Report configuration
          #
          # @param [Mutest::Config] config
          #
          # @return [undefined]
          def run
            info 'Mutest configuration:'
            info 'Matcher:         %s',      object.matcher.inspect
            info 'Integration:     %s',      object.integration
            info 'Jobs:            %d',      object.jobs
            info 'Includes:        %s',      object.includes
            info 'Requires:        %s',      object.requires
          end
        end
      end
    end
  end
end
