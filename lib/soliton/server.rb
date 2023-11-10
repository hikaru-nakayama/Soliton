# frozen_string_literal: true
require "soliton/http/responder"
require "soliton/http/request_parser"
require "socket"
require "soliton/logger"
require 'openssl'
require 'singleton'

module Soliton
  class Server
    class Configuration
      include Singleton
      attr_accessor :port, :host, :ssl_cert, :ssl_key, :ssl_enabled
    end
    include OpenSSL
    PORT = ENV.fetch("PORT", 3000)
    HOST = ENV.fetch("HOST", "127.0.0.1").freeze
    attr_accessor :app

    # app: Rackアプリ
    def initialize(app)
      self.app = app
    end

    def start
      server_setting = Server::Configuration.instance

      socket = server_setting.ssl_enabled ? listen_on_socket_with_ssl(server_setting.ssl_cert, server_setting.ssl_key) : listen_on_socket
      logger = Logger.new($stdout)
      logger.info "Soliton is running on #{HOST}:#{PORT}"
      loop do # 新しいコネクションを継続的にリッスンする
        conn, _addr_info = socket.accept
        request = Http::RequestParser.call(conn)
        status, headers, body = app.call(request)
        Http::Responder.call(conn, status, headers, body)
      rescue StandardError => e
        logger.error e
      ensure # コネクションを常にクローズする
        logger.info "Completed #{status} #{Http::Responder::STATUS_MESSAGES[status]}"
        conn&.close
      end
    end

    def listen_on_socket_with_ssl(cert, key)
      ctx = SSL::SSLContext.new
      ctx.cert = X509::Certificate.new(File.read(cert))
      ctx.key = PKey::RSA.new(File.read(key))
      svr = TCPServer.new(HOST, PORT)
      SSL::SSLServer.new(svr, ctx)
    end

    def listen_on_socket
      TCPServer.new(HOST, PORT)
    end
  end
end
