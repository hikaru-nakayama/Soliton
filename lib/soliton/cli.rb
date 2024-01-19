# frozen_string_literal: true

require "thor"

module Soliton
  class CLI < Thor
    desc "server", "start server"
    def server
      puts File.read("#{File.dirname(__FILE__)}/templates/soliton.txt")
      Soliton::App.start
    end
  end
end
