# frozen_string_literal: true

module Soliton
  class Logger
    class Formatter
      FORMAT = "%.1s, [%s #%d] %5s -- %s\n"
      DATETIME_FORMAT = "%Y-%m-%dT%H:%M:%S.%6N"

      def call(severity, time, msg)
        format(
          FORMAT,
          severity,
          time.strftime(DATETIME_FORMAT),
          Process.pid,
          severity,
          msg2str(msg)
        )
      end

      private

      def msg2str(msg)
        case msg
        when ::String
          msg
        when ::Exception
          "#{msg.message} (#{msg.class})\n#{msg&.backtrace&.join("\n")}"
        else
          msg.inspect
        end
      end
    end
  end
end
