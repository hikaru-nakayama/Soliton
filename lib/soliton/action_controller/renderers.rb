require 'json'
module Soliton
    module ActionController
        module Renderers
            RENDERERS = Set.new

            def self.included(mod)
                @@_renderers = RENDERERS
            end

            def render_to_body(options)
              @@_renderers.each do |name|
                 if options.key?(name)
                    return send(name, options[name])
                 end
              end
            end

            def self.add(key, &block)
              define_method(key, &block)
              RENDERERS << key.to_sym
            end

            add :json do |json|
              json = json.to_json unless json.kind_of?(String)
              [json, "application/json"]
            end

            add :template do |rel_path|
              ROOT_DIR = Soliton::Application.config.root
              path = "#{ROOT_DIR}/views/#{rel_path}"
              html = File.exist?(path) ? File.read(path) : nil
              [html, "text/html"]
            end
        end
    end
end