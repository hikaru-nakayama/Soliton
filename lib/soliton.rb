# frozen_string_literal: true
require_relative "soliton/server"
require_relative "soliton/application"
require_relative "soliton/version"

module Soliton
  def self.start
    server = Server.new(Application.new)
    server.start
  end
end
