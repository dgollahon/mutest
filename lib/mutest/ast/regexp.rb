module Mutest
  module AST
    # Regexp source mapper
    module Regexp
      # Parse regex string into expression
      #
      # @param regexp [String]
      #
      # @return [Regexp::Expression::Base]
      def self.parse(regexp)
        ::Regexp::Parser.parse(regexp)
      end

      # Convert expression into ast node
      #
      # @param expression [Regexp::Expression::Base]
      #
      # @return [Parser::AST::Node]
      def self.to_ast(expression)
        ast_type = :"regexp_#{expression.token}_#{expression.type}"

        Transformer.lookup(ast_type).to_ast(expression)
      end

      # Convert node into expression
      #
      # @param node [Parser::AST::Node]
      #
      # @return [Regexp::Expression::Base]
      def self.to_expression(node)
        Transformer.lookup(node.type).to_expression(node)
      end
    end # Regexp
  end # AST
end # Mutest
