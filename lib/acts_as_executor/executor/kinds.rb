module ActsAsExecutor
  module Executor
    class Kinds
      SCHEDULED = "scheduled"
      SINGLE_SCHEDULED = "single_scheduled"

      ALL = [ SCHEDULED, SINGLE_SCHEDULED ]
      ALL_SCHEDULED = [ SCHEDULED, SINGLE_SCHEDULED ]
      REQUIRING_SIZE = [ SCHEDULED ]
    end
  end
end