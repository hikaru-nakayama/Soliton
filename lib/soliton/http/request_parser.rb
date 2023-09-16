require "uri"

module Soliton
  module Http
    class RequestParser
      class << self
        MAX_URI_LENGTH = 2083 # HTTP標準に準拠
        MAX_HEADER_LENGTH = (112 * 1024) # WebrickやPumaなどのサーバーではこう定義する

        def call(conn)
          method, full_path, path, query = read_request_line(conn)

          headers = read_headers(conn)

          body = read_body(conn: conn, method: method, headers: headers)

          # リモート接続に関する情報を読み取る
          peeraddr = conn.peeraddr
          remote_host = peeraddr[2]
          remote_address = peeraddr[3]

          # 利用するポート
          port = conn.addr[1]
          {
            "REQUEST_METHOD" => method,
            "PATH_INFO" => path,
            "QUERY_STRING" => query,
            # rack.inputはIOストリームである必要がある
            "rack.input" => body ? StringIO.new(body) : nil,
            "REMOTE_ADDR" => remote_address,
            "REMOTE_HOST" => remote_host,
            "REQUEST_URI" =>
              make_request_uri(
                full_path: full_path,
                port: port,
                remote_host: remote_host
              )
          }.merge(rack_headers(headers))
        end

        def read_request_line(conn)
          # 改行に達するまで読み取る、最大長はMAX_URI_LENGTHを指定
          request_line = conn.gets("\n", MAX_URI_LENGTH)

          method, full_path, _http_version = request_line.strip.split(" ", 3)

          path, query = full_path.split("?", 2)

          [method, full_path, path, query]
        end

        def read_headers(conn)
          headers = {}
          loop do
            line = conn.gets("\n", MAX_HEADER_LENGTH)&.strip

            break if line.nil? || line.strip.empty?

            # ヘッダー名と値はコロンとスペースで区切られる
            key, value = line.split(/:\s/, 2)

            headers[key] = value
          end

          headers
        end

        def rack_headers(headers)
          # Rackは、全ヘッダーがHTTP_がプレフィックスされ
          # かつ大文字であることを期待する
          headers.transform_keys { |key| "HTTP_#{key.upcase}" }
        end

        def read_body(conn:, method:, headers:)
          return nil unless %w[POST PUT].include?(method)

          remaining_size = headers["content-length"].to_i

          conn.read(remaining_size)
        end

        def make_request_uri(full_path:, port:, remote_host:)
          request_uri = URI.parse(full_path)
          request_uri.scheme = "http"
          request_uri.host = remote_host
          request_uri.port = port
          request_uri.to_s
        end
      end
    end
  end
end
