# frozen_string_literal: true
module Soliton
  class Logger
    require "soliton/logger/formatter"
    require "soliton/logger/log_device"
    attr_reader :logdev, :formatter

    def initialize(logdev)
      @logdev = LogDevice.new(logdev)
      @formatter = Formatter.new
    end

    %i[info error fatal warn debug].each do |level|
      define_method(level) do |msg|
        logdev.write(formatter.call(level.capitalize, Time.now, msg))
      end
    end
  end
end
