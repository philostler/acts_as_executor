module ActsAsExecutor
  module Executor
    module Model
      module Helpers
        def can_startup?
          if self.executor == nil && ActsAsExecutor.rails_booted?
            return true
          end
          return false
        end

        def can_shutdown?
          if self.executor != nil && ActsAsExecutor.rails_booted?
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