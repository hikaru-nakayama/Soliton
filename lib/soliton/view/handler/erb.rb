# frozen_string_literal: true

require "erb"

module Soliton
  module View
    module Handler
      class ERB
        def call(source)
          ::ERB.new(source).src
        end

        private

        def valid_encoding(string, encoding)
          string.force_encoding(encoding) if encoding
        end
      end
    end
  end
end
