module Mutest
  module AST
    # Module for node predicates
    module NodePredicates
      Types::ALL.each do |type|
        raise "method: #{type} is already defined" if instance_methods(true).include?(type)

        name = "n_#{type.to_s.chomp('?')}?"

        define_method(name) do |node|
          node.type.equal?(type)
        end
        private name
      end
    end
  end
end
