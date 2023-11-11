# frozen_string_literal: true
module Soliton
  module Middleware
    class Cookie
      def initialize(app)
        @app = app
      end

      def call(env)
        cookie_jar = CookieJar.build(env, extract_cookies(env))
        env['soliton.cookies'] = cookie_jar
        status, headers, body = @app.call(env)
        headers['Set-Cookie'] = cookie_jar.to_header
        [status, headers, body]
      end

      def extract_cookies(env)
        env['HTTP_COOKIE'].split(';').reduce({}) do |acc, cookie|
          key, value = cookie.split("=")
          acc.update(key.strip => value.strip)
        end
      end
    end
  end

   module Cookies
      def cookies
         # TODO request の取得方法を変更する
         request = Soliton::Context.instance.context
         request['soliton.cookies']
      end
   end

  class CookieJar
    def self.build(req, cookies)
      new(req).tap do |hash|
        hash.update(cookies)
      end
    end

    attr_reader :request

    def initialize(request)
      @set_cookies = {}
      @delete_cookies = {}
      @request = request
      @cookies = {}
    end

    def [](name)
      @cookies[name.to_s]
    end

    def []=(name, options)
      if options.is_a?(Hash)
        options.symbolize_keys!
        value = options[:value]
      else
        value = options
        options = { value: value }
      end

      if @cookies[name.to_s] != value || options[:expires]
        @cookies[name.to_s] = value
        @set_cookies[name.to_s] = options
        @delete_cookies.delete(name.to_s)
      end
        value
    end

    def update(other_hash)
      @cookies.update other_hash
      self
    end

    def to_header
      @set_cookies.map {|k, v| "#{k}=#{v}" }.join "; "
    end
  end
end
