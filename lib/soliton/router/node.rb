# frozen_string_literal: true

require "soliton/router/segment"

module Soliton
  class Router
    class Node
      attr_reader :to

      def initialize
        @variable = nil
        @fixed = nil
        @to = nil
      end

      def put(segment)
        if variable?(segment)
          @variable ||= {}
          @variable[segment_for(segment)] ||= self.class.new
        else
          @fixed ||= {}
          @fixed[segment] ||= self.class.new
        end
      end

      def get(segment)
        return unless @variable || @fixed

        found = nil
        captured = nil

        found = @fixed&.fetch(segment, nil)
        return found, nil if found

        @variable&.each do |matcher, node|
          break if found

          captured = matcher.match(segment)
          found = node if captured
        end

        [found, captured&.named_captures]
      end

      def leaf?
        @to
      end

      def leaf!(to)
        @to = to
      end

      private

      ROUTE_VARIABLE_MATCHER = /:/
      def variable?(segment)
        ROUTE_VARIABLE_MATCHER.match?(segment)
      end

      def segment_for(segment)
        Segment.fabricate(segment)
      end
    end
  end
end
