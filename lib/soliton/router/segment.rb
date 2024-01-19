# frozen_string_literal: true

module Soliton
  class Router
    class Segment
      def initialize(segment)
        @segment = segment.delete(":")
      end

      def match(segment)
        { @segment => segment }
      end

      class << self
        def fabricate(segment)
          new(segment)
        end
      end
    end
  end
end
