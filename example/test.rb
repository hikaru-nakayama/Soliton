require "soliton/router"

Soliton::Router.routing do
  get "/hello/:id", to: ->(env) { [200, {}, ["Hello, World!"]] }
end

