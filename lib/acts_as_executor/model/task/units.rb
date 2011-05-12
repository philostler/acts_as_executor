module ActsAsExecutor
  module Model
    module Task
      class Units
        NANOSECONDS = "nanoseconds"
        MICROSECONDS = "microseconds"
        MILLISECONDS = "milliseconds"
        SECONDS = "seconds"
        MINUTES = "minutes"
        HOURS = "hours"
        DAYS = "days"

        ALL = [ NANOSECONDS, MICROSECONDS, MILLISECONDS, SECONDS, MINUTES, HOURS, DAYS ]
      end
    end
  end
end