# frozen_string_literal: true
require "soliton/server"
require "soliton/application"
require "soliton/version"
require "soliton/test"

module Soliton
  class App
    def self.start
      app = Application.new(Router.instance)
      server = Server.new(app)
      server.start
    end
  end
end

Soliton::App.start
