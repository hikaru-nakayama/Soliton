# frozen_string_literal: true

require "securerandom"

module Soliton
  module View
    class Template
      def initialize(source, handler)
        @handler = handler
        @source = source
      end

      def render(view)
        compile(view)
        view._run(method_name)
      end

      def compile(view)
        code = @handler.call(@source.to_s)
        source = +<<-END_SRC
            def #{method_name}
              #{code}
            end
        END_SRC
        view.class.module_eval(source)
      end

      def method_name
        @method_name ||= "render_#{SecureRandom.hex(10)}"
      end
    end
  end
end
