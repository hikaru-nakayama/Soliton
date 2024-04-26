# Soliton
Web framework built with the ruby

### Installation

```
gem build soliton.gemspec
gem install soliton-0.1.0.gem
```

### Usage

```
Soliton server
```

### Get Started

```ruby
require "soliton/router"

Soliton::Router.routing do
  get "/hello/:id", to: ->(env) { [200, {}, ["Hello, World!"]] }
end

class User
    attr_accessor :id
    def initialize(id)
        @id = id
    end
end

class IndexAction < Soliton::ActionController::Base
    def call(env)
        @user = User.new(1)
        render template: "index.html.erb"
    end
end

```
