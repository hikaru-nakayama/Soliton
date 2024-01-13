# frozen_string_literal: true
require "singleton"
module Soliton
  # Rackアプリケーション
  class Application
    def initialize(router)
      @router = router
    end

    def call(env)
      # ここで CORS などの middoleware の実行を行う
      Soliton::Context.instance.init(env)
      @router.call(env)
    end

    class Configuration
      include Singleton
      attr_accessor :root

      def initialize
        @root = Dir.pwd
      end
    end

    class << self
      def config
        Configuration.instance
      end
    end

  end

  class Context
    include Singleton
    attr_accessor :context

    def init(env)
      @context = env
    end
  end
end
