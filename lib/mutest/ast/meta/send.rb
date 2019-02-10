module Mutest
  module AST
    # Node meta information mixin
    module Meta
      # Metadata for send nodes
      class Send
        include NodePredicates
        include Concord.new(:node)
        include NamedChildren

        children :receiver, :selector

        public :receiver, :selector

        INDEX_ASSIGNMENT_SELECTOR            = :[]=
        ATTRIBUTE_ASSIGNMENT_SELECTOR_SUFFIX = '='.freeze
        METHOD_METHOD_SELECTORS              = %i[method public_method].freeze

        # Arguments of mutated node
        #
        # @return [Enumerable<Parser::AST::Node>]
        alias_method :arguments, :remaining_children

        public :arguments

        # Test if node is defining a proc
        #
        # @return [Boolean]
        def proc?
          naked_proc? || proc_new?
        end

        # Test if AST node is a valid attribute assignment
        #
        # @return [Boolean]
        def attribute_assignment?
          !Types::METHOD_OPERATORS.include?(selector) &&
            selector.to_s.end_with?(ATTRIBUTE_ASSIGNMENT_SELECTOR_SUFFIX)
        end

        # Test for binary operator implemented as method
        #
        # @return [Boolean]
        def binary_method_operator?
          Types::BINARY_METHOD_OPERATORS.include?(selector)
        end

        # Test if receiver is possibly a top level constant
        #
        # @return [Boolean]
        def receiver_possible_top_level_const?
          return false unless receiver && n_const?(receiver)

          Const.new(receiver).possible_top_level?
        end

        # Test if this is a selector that returns a method object
        def method_object_selector?
          METHOD_METHOD_SELECTORS.include?(selector)
        end

        private

        # Test if node is `proc { ... }`
        #
        # @return [Boolean]
        def naked_proc?
          !receiver && selector.equal?(:proc)
        end

        # Test if node is `Proc.new { ... }`
        #
        # @return [Boolean]
        def proc_new?
          receiver                &&
            selector.equal?(:new) &&
            n_const?(receiver)    &&
            Const.new(receiver).name.equal?(:Proc)
        end
      end
    end
  end
end
