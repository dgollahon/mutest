module Mutest
  # Generator for mutations
  class Mutator
    REGISTRY = Registry.new

    include Procto.call(:output)
    include AbstractType
    include Concord.new(:input, :filter, :parent)
    include Adamantium::Flat

    # Lookup and invoke dedicated AST mutator
    #
    # @param node [Parser::AST::Node]
    # @param parent [nil,Mutest::Mutator::Node]
    #
    # @return [Set<Parser::AST::Node>]
    def self.mutate(node, filter = ->(_) {}, parent = nil)
      self::REGISTRY.lookup(node.type).call(node, filter, parent)
    end

    # Register node class handler
    #
    # @return [undefined]
    def self.handle(*types)
      types.each do |type|
        self::REGISTRY.register(type, self)
      end
    end
    private_class_method :handle

    # Return output
    #
    # @return [Set<Parser::AST::Node>]
    attr_reader :output

    private

    # Initialize object
    #
    # @param [Object] input
    # @param [#call] mutation filter
    # @param [Object] parent
    # @param [#call(node)] block
    #
    # @return [undefined]
    def initialize(_input, _filter, _parent = nil)
      super

      @output = Set.new

      dispatch unless disabled?
    end

    def disabled?
      filter.call(input)
    end

    # Test if generated object is not guarded from emitting
    #
    # @param [Object] object
    #
    # @return [Boolean]
    def new?(object)
      !object.eql?(input)
    end

    # Dispatch node generations
    #
    # @return [undefined]
    abstract_method :dispatch

    # Emit generated mutation if object is not equivalent to input
    #
    # @param [Object] object
    #
    # @return [undefined]
    def emit(object)
      return unless new?(object)

      output << object
    end

    # Shortcut to create a new unfrozen duplicate of input
    #
    # @return [Object]
    def dup_input
      input.dup
    end

    # Mutate child nodes within source path
    #
    # @return [Set<Parser::AST::Node>]
    def mutate(node, parent = nil)
      self.class.mutate(node, filter, parent)
    end

    # Run input with mutator
    #
    # @return [undefined]
    def run(mutator)
      mutate_with(mutator, input)
    end

    # Mutate nodes using a specific mutator class
    #
    # @yield [Object] value emitted by provided mutator
    #
    # @return [undefined]
    def mutate_with(mutator, nodes, &block)
      block ||= method(:emit)

      mutator.call(nodes, filter).each(&block)
    end
  end
end
