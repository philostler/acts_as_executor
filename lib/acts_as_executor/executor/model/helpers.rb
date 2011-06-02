module ActsAsExecutor
  module Executor
    module Model
      module Helpers
        def startup_now?
          unless self.executor && ActsAsExecutor.rails_startup?
            return true
          end
          return false
        end

        def shutdown_now?
          if self.executor && ActsAsExecutor.rails_startup?
            return true
          end
          return false
        end

        def schedulable?
          ActsAsExecutor::Executor::Kinds::ALL_SCHEDULED.include? kind
        end
      end
    end
  end
end