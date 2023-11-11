# frozen_string_literal: true
require "soliton/server"
require "soliton/application"
require "soliton/version"
require "soliton/router"

module Soliton
  class App
    def self.start
      # ここに middleware を追加する処理を書く
      app = Application.new(Router.instance)
      server = Server.new(app)
      server.start
    end
  end
end
