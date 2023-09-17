# frozen_string_literal: true
require "soliton/router/node"

module Soliton
  class Router
    class Trie
      attr_reader :root

      def initialize
        @root = Node.new
      end

      def add(path, to)
        node = @root
        for_each_segment(path) { |segment| node = node.put(segment) }

        node.leaf!(to)
      end

      def find(path)
        node = @root
        params = {}

        for_each_segment(path) do |segment|
          break unless node

          child, captures = node.get(segment)
          params.merge!(captures) if captures

          node = child
        end

        return node.to, params if node&.leaf?

        nil
      end

      private

      SEGMENT_SEPARATOR = %r{/}
      private_constant :SEGMENT_SEPARATOR

      def for_each_segment(path, &blk)
        _, *segments = path.split(SEGMENT_SEPARATOR)
        segments.each(&blk)
      end
    end
  end
end
