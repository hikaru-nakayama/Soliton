# frozen_string_literal: true

module Soliton
  module Middleware
    class Cookie
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)
        headers['Set-Cookie'] = 'foo=bar'
        [status, headers, body]
      end
    end
  end
end
