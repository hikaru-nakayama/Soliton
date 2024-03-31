# frozen_string_literal: true

require "soliton/http/responder"
require "soliton/http/request_parser"
require "soliton/middleware/builder"
require "soliton/middleware/cookie"
require "socket"
require "soliton/logger"
require "openssl"
require "singleton"
require "soliton/error"
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
      @app = app
    end

    def start
      server_setting = Server::Configuration.instance
      application = @app
      register_signal_handlers

      socket =
        (
          if server_setting.ssl_enabled
            listen_on_socket_with_ssl(
              server_setting.ssl_cert,
              server_setting.ssl_key
            )
          else
            listen_on_socket
          end
        )
      logger = Logger.new($stdout)
      logger.info "Soliton is running on #{HOST}:#{PORT}"
      loop do # 新しいコネクションを継続的にリッスンする
        @status = "waiting"
        conn, _addr_info = socket.accept
        @status = "running"
        if IO.select([conn], nil, nil, 5)
          fork do
            request = Http::RequestParser.call(conn)
            builder =
              Soliton::Middleware::Builder.new do
                use Soliton::Middleware::Cookie
                run application
              end
            status, headers, body = builder.call(request)
            Http::Responder.call(conn, status, headers, body)
          rescue StandardError => e
            logger.error e
          ensure # コネクションを常にクローズする
            logger.info "Completed #{status} #{Http::Responder::STATUS_MESSAGES[status]}"
            conn&.close
          end
        else
          conn&.close
        end
      rescue Soliton::TermException
        # 何もしない
      ensure
        conn&.close
        if @shutdown
          Process.waitall
          break
        end
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

    private

    def register_signal_handlers
      logger = Logger.new($stdout)
      trap('TERM') do
        logger.info "gracefull shutdown..."
        @status == "waiting" ? shutdown! : shutdown
      end
      trap('INT') do
        logger.info "gracefull shutdown..."
        @status == "waiting" ? shutdown! : shutdown
      end
    end

    def shutdown
      @shutdown = true
    end

    def shutdown!
      @shutdown = true
      raise Soliton::TermException, "KILL"
    end
  end
end
