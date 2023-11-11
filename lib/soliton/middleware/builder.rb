# frozen_string_literal: true
module Soliton
  module Middleware
    class Builder
      def initialize(&block)
        @use = []
        instance_eval(&block) if block_given?
      end

      def use(middleware, *args, &block)
        @use << proc {|app| middleware.new(app, *args, &block) }
      end

      def run(app)
        @app = app
      end

      def call(env)
        build_app.call(env)
      end

      private

      def build_app
        @use.reverse.inject(@app) {|a, e| e.call(a) }
      end
    end
  end
end
