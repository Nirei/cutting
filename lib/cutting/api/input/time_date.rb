# frozen_string_literal: true

require_relative "../../constants"

module Cutting
  module Api
    module Input
      # Used to read the time
      module TimeDate
        # Returns the current day as a value from 1 - 31
        def day
          Time.new.day
        end

        # Returns the current hour as a value from 0 - 23
        def hour
          Time.new.hour
        end

        # Returns the number of milliseconds (thousandths of a second) since starting an applet
        def millis
          (Time.new.nsec * 1_000_000) - context.start_time
        end

        # Returns the current minute as a value from 0 - 59
        def minute
          Time.new.minute
        end

        # Returns the current month as a value from 1 - 12
        def month
          Time.new.month
        end

        # Returns the current second as a value from 0 - 59
        def second
          Time.new.second
        end

        # Returns the current year as an integer (2003, 2004, 2005, etc)
        def year
          Time.new.year
        end
      end
    end
  end
end
