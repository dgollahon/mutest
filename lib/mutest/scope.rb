module Mutest
  # Class or Module bound to an exact expression
  class Scope
    include Concord::Public.new(:raw, :expression)
  end
end
