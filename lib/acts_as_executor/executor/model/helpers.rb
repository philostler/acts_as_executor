module ActsAsExecutor
  module Executor
    module Model
      module Helpers
        def schedulable?
          ActsAsExecutor::Executor::Kinds::ALL_SCHEDULED.include? kind
        end
      end
    end
  end
end