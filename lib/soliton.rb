# frozen_string_literal: true

require "soliton/main"

module Soliton
  class << self
    def configure
      yield configuration
    end

    def configuration
      Server::Configuration.instance
    end
  end
end
