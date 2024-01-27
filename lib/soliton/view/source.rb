# frozen_string_literal: true

module Soliton
  module View
    class Source
      def initialize(filename)
        @filename = filename
      end

      def to_s
        ::File.binread @filename
      end
    end
  end
end
