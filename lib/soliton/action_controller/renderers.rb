# frozen_string_literal: true

require "soliton/view/rendering"
require "json"
module Soliton
  module ActionController
    module Renderers
      include Soliton::View::Rendering
      RENDERERS = Set.new

      def self.included(_mod)
        @@_renderers = RENDERERS # rubocop:disable Style/ClassVars
      end

      def render_to_body(options)
        @@_renderers.each do |name|
          return send(name, options[name]) if options.key?(name)
        end
      end

      def self.add(key, &block)
        define_method(key, &block)
        RENDERERS << key.to_sym
      end

      add :json do |json|
        json = json.to_json unless json.is_a?(String)
        [json, "application/json"]
      end

      add :template do |rel_path|
        root_dir = Soliton::Application.config.root
        path = "#{root_dir}/views/#{rel_path}"
        body = render_template(path)
        [body, "text/html"]
      end
    end
  end
end
