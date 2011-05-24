module ActsAsExecutor
  module Task
    class Schedules
      ONE_SHOT = "one_shot"
      FIXED_DELAY = "fixed_delay"
      FIXED_RATE = "fixed_rate"

      ALL = [ ONE_SHOT, FIXED_DELAY, FIXED_RATE ]
    end
  end
end