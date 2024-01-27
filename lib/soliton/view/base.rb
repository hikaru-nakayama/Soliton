# frozen_string_literal: true

module Soliton
  module View
    class Base
      def assign(new_assigns)
        @_assigns =
          new_assigns.each do |key, value|
            instance_variable_set("@#{key}", value)
          end
      end

      def initialize(controller)
        assign(controller.view_assigns)
      end

      def _run(method)
        public_send(method)
      end
    end
  end
end
