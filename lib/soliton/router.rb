require "rack"
require "rack/utils"
require "singleton"

module Soliton
  class Router
    include Singleton
    require "soliton/router/trie"
    require "soliton/router/node"

    def self.routing(&)
      instance.instance_eval(&)
    end

    def initialize(resolver: DEFAULT_RESOLVER, &blk)
      @resolver = resolver
      @fixed = {}
      @variable = {}
      instance_eval(&blk) if block_given?
    end

    def call(env)
      endpoint, params = lookup(env)

      endpoint.call(_params(env, params)).to_a
    end

    def lookup(env)
      endpoint = fixed(env)
      return endpoint, {} if endpoint

      variable(env)
    end

    def fixed(env)
      @fixed.dig(env["REQUEST_METHOD"], env["PATH_INFO"])
    end

    def variable(env)
      @variable[env["REQUEST_METHOD"]]&.find(env["PATH_INFO"])
    end

    def get(path, to: nil, &blk)
      add_route("GET", path, to, &blk)
    end

    def add_route(http_method, path, to, &blk)
      endpoint = resolve_endpoint(path, to, blk)

      if variable?(path)
        add_variable_route(http_method, path, endpoint)
      else
        add_fixed_route(http_method, path, endpoint)
      end
    end

    def resolve_endpoint(path, to, _)
      @resolver.call(path, to)
    end

    def add_variable_route(http_method, path, to)
      @variable[http_method] ||= Trie.new
      @variable[http_method].add(path, to)
    end

    def add_fixed_route(http_method, path, to)
      @fixed[http_method] ||= {}
      @fixed[http_method][path] = to
    end

    def variable?(path)
      Node::ROUTE_VARIABLE_MATCHER.match?(path)
    end

    def _params(env, params)
      params ||= {}
      env[PARAMS] ||= {}

      if !env.key?(ROUTER_PARSED_BODY) && (input = env[::Rack::RACK_INPUT]) and
         input.rewind
        env[PARAMS].merge!(::Rack::Utils.parse_nested_query(input.read))
        input.rewind
      end

      env[PARAMS].merge!(
        ::Rack::Utils.parse_nested_query(env[::Rack::QUERY_STRING])
      )
      env[PARAMS].merge!(params)
      #   env[PARAMS] = Params.deep_symbolize(env[PARAMS])
      env
    end

    DEFAULT_RESOLVER = ->(_, to) { to }
  end
end
