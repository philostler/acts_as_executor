module ActsAsExecutor
  module Executor
    class Kinds
      CACHED = "cached"
      FIXED = "fixed"
      SINGLE = "single"

      SCHEDULED = "scheduled"
      SINGLE_SCHEDULED = "single_scheduled"

      ALL = [ CACHED, FIXED, SINGLE, SCHEDULED, SINGLE_SCHEDULED ]
      ALL_SCHEDULED = [ SCHEDULED, SINGLE_SCHEDULED ]
      REQUIRING_SIZE = [ FIXED, SCHEDULED ]
    end
  end
end