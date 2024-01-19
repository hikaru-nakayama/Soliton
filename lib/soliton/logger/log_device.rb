# frozen_string_literal: true

module Soliton
  class Logger
    class LogDevice
      def initialize(log)
        @dev = set_dev(log)
      end

      def write(message)
        @dev.write(message)
      rescue StandardError
        warn("log writing failed.")
      end

      private

      def set_dev(log) # rubocop:disable Naming/AccessorMethodName
        log.respond_to?(:write) ? log : File.open(log, "w")
      end
    end
  end
end
