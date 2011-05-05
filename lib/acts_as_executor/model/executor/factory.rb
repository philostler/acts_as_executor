module ActsAsExecutor
  module Model
    module Executor
      class Factory
        def self.create kind, size = nil
          case kind
            when ActsAsExecutor::Model::Executor::Kinds::CACHED
              return Java::java.util.concurrent.Executors.new_cached_thread_pool
            when ActsAsExecutor::Model::Executor::Kinds::FIXED
              raise TypeError, "size cannot be nil" unless size
              raise ArgumentError, "size must be larger than 0" unless size.to_i > 0
              return Java::java.util.concurrent.Executors.new_fixed_thread_pool size.to_i
            when ActsAsExecutor::Model::Executor::Kinds::SINGLE
              return Java::java.util.concurrent.Executors.new_single_thread_executor
            when ActsAsExecutor::Model::Executor::Kinds::SCHEDULED
              raise TypeError, "size cannot be nil" unless size
              raise ArgumentError, "size must be larger than 0" unless size.to_i > 0
              return Java::java.util.concurrent.Executors.new_scheduled_thread_pool size.to_i
            when ActsAsExecutor::Model::Executor::Kinds::SINGLE_SCHEDULED
              return Java::java.util.concurrent.Executors.new_single_thread_scheduled_executor
            else
              return nil
          end
        end
      end
    end
  end
end