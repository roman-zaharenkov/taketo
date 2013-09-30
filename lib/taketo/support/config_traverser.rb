require 'delegate'
require 'forwardable'

module Taketo
  module Support

    class ConfigTraverser
      def initialize(root)
        @root = root
      end

      def visit_depth_first(visitor)
        path_stack = [@root]

        while path_stack.any?
          node = path_stack.pop
          visitor.visit(node)

          node.nodes.reverse_each do |n|
            path_stack.push(n)
          end
        end
      end
    end

  end
end
