module Soliton
  module Http
    class Responder
      STATUS_MESSAGES = { 200 => "OK", 404 => "Not Found" }.freeze

      def self.call(conn, status, headers, body)
        # ステータス行
        status_text = STATUS_MESSAGES[status]
        conn.write("HTTP/1.1 #{status} #{status_text}\r\n")

        content_length = body.sum(&:length)
        conn.write("Content-Length: #{content_length}\r\n")
        headers.each_pair do |name, value|
          conn.write("#{name}: #{value}\r\n")
        end

        # コネクションを開きっぱなしにしたくないことを伝える
        conn.write("Connection: close\r\n")

        # ヘッダーと本文の間を空行で区切る
        conn.write("\r\n")

        # 本文
        body.each { |chunk| conn.write(chunk) }
      end
    end
  end
end
