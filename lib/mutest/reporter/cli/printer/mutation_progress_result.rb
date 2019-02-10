module Mutest
  class Reporter
    class CLI
      class Printer
        # Printer for mutation progress results
        class MutationProgressResult < self
          SUCCESS = '.'.freeze
          FAILURE = 'F'.freeze

          # Run printer
          #
          # @return [undefined]
          def run
            char(success? ? SUCCESS : FAILURE)
          end

          private

          # Write colorized char
          #
          # @param [String] char
          #
          # @return [undefined]
          def char(char)
            output.write(colorize(status_color, char))
          end
        end
      end
    end
  end
end
