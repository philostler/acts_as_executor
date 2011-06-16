module ActsAsExecutor
  module Executor
    module Model
      module Logger
        def logger
          @@logger ||= Rails.logger
        end
        def logger= logger
          @@logger = logger
        end
      end
    end
  end
end