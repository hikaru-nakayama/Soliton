require "soliton/action_controller/renderers"
module Soliton
    module ActionController
        module Helper
        include Renderers
            # options の key は template, json に対応
            # template: "review/new" だと、views/review/new.html.erb を返す
            # json: @user だと、user を json に変換して返す.
            def render(options={})
              body, content_type = render_to_body(options)
              [200, {"Content-type": content_type}, [body]]
            end
        end
    end
end