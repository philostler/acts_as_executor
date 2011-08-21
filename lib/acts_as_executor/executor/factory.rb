module ActsAsExecutor
  module Executor
    class Factory
      def self.create max_tasks, schedulable
        executor = nil
        if schedulable
          if max_tasks == nil
            # No Cached Scheduled Implementation
          elsif max_tasks >  1
            executor = Java::java.util.concurrent.Executors.new_scheduled_thread_pool max_tasks.to_i # Scheduled
          else
            executor = Java::java.util.concurrent.Executors.new_single_thread_scheduled_executor # Single Scheduled
          end
        else
          if max_tasks == nil
            executor = Java::java.util.concurrent.Executors.new_cached_thread_pool # Cached
          elsif max_tasks > 1
            executor = Java::java.util.concurrent.Executors.new_fixed_thread_pool max_tasks.to_i # Fixed
          else
            executor = Java::java.util.concurrent.Executors.new_single_thread_executor # Single
          end
        end
        executor
      end
    end
  end
end