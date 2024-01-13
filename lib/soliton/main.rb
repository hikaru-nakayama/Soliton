# frozen_string_literal: true
require "soliton/server"
require "soliton/application"
require "soliton/version"
require "soliton/router"

module Soliton
  class App
    def self.start
      # Rack app の初期化
      app = Application.new(Router.instance)

      # config を読み込む
      config_dir = File.expand_path('config', Dir.pwd)
      Dir["#{config_dir}/**/*.rb"].each do |file|
        next if File.directory?(file)

        require file
      end

      # サーバーの起動
      server = Server.new(app)
      server.start
    end
  end
end
