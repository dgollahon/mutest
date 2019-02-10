module Mutest
  module Meta
    class Example
      # Example DSL
      class DSL
        include AST::Sexp

        # Run DSL on block
        #
        # @return [Example]
        def self.call(file, type, block)
          instance = new(file, type)
          instance.instance_eval(&block)
          instance.example
        end

        private_class_method :new

        # Initialize object
        #
        # @return [undefined]
        def initialize(file, type)
          @file     = file
          @type     = type
          @node     = nil
          @expected = []
        end

        # Example captured by DSL
        #
        # @return [Example]
        #
        # @raise [RuntimeError]
        #   in case example cannot be build
        def example
          raise 'source not defined' unless @node

          Example.new(
            file:      @file,
            node:      @node,
            node_type: @type,
            expected:  @expected
          )
        end

        private

        # Set original source
        #
        # @param [String,Parser::AST::Node] input
        #
        # @return [undefined]
        def source(input)
          raise 'source already defined' if @node

          @node = node(input)
        end

        # Add expected mutation
        #
        # @param [String,Parser::AST::Node] input
        #
        # @return [undefined]
        def mutation(input)
          node = node(input)
          raise "Mutation for input: #{input.inspect} is already expected" if @expected.include?(node)

          @expected << node
        end

        # Add singleton mutations
        #
        # @return [undefined]
        def singleton_mutations
          mutation('nil')
          mutation('self')
        end

        # Add regexp mutations
        #
        # @return [undefined]
        def regexp_mutations
          mutation('//')
          mutation('/nomatch\A/')
        end

        # Helper method to coerce input to node
        #
        # @param [String,Parser::AST::Node] input
        #
        # @return [Parser::AST::Node]
        #
        # @raise [RuntimeError]
        #   in case input cannot be coerced
        def node(input)
          case input
          when String
            Unparser::Preprocessor.run(::Parser::CurrentRuby.parse(input))
          when ::Parser::AST::Node
            input
          else
            raise "Cannot coerce to node: #{input.inspect}"
          end
        end
      end
    end
  end
end
