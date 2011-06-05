module ActsAsExecutor
  module Task
    module Model
      module Helpers
        def execute_now?
          if self.future == nil
            return true
          end
          return false
        end
      end
    end
  end
end