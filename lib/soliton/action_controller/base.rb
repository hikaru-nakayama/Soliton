# frozen_string_literal: true

require "soliton/action_controller/helper"

# 利用方法は以下を想定
# MyAction < Soliton::ActionController::Base
#   def call(env)
#     render template: "revirew/new"
#   end
# end

module Soliton
  module ActionController
    class Base
      include Helper
    end
  end
end
