module Mutest
  class Mutator
    class Node
      # Mutator for resbody nodes
      class Resbody < self
        handle(:resbody)

        children :captures, :assignment, :body

        private

        # Emit mutations
        #
        # @return [undefined]
        def dispatch
          emit_assignment(:RemoveRescueAssignment, nil)
          emit_body_mutations if body
          mutate_captures
        end

        # Mutate captures
        #
        # @return [undefined]
        def mutate_captures
          return unless captures
          mutate_with(Util::Array::Element, captures.children) do |matchers|
            next if matchers.any?(&method(:n_nil?))
            emit_captures(:RemoveRescueCapture, s(:array, *matchers))
          end
        end
      end # Resbody
    end # Node
  end # Mutator
end # Mutest
