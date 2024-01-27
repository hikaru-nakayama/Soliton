# frozen_string_literal: true

require "soliton/view/base"
require "soliton/view/source"
require "soliton/view/template"
require "soliton/view/handler/erb"

module Soliton
  module View
    module Rendering
      def view
        Soliton::View::Base.new(self)
      end

      def render_template(path)
        source = Soliton::View::Source.new(path)
        Soliton::View::Template.new(
          source,
          Soliton::View::Handler::ERB.new
        ).render(view)
      end
    end
  end
end
