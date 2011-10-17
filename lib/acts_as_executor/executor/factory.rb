module ActsAsExecutor
  module Executor
    class Factory
      def self.create limit
        executor = Java::java.util.concurrent.Executors.new_scheduled_thread_pool limit.to_i

        executor.continue_existing_periodic_tasks_after_shutdown_policy = false
        executor.execute_existing_delayed_tasks_after_shutdown_policy = false

        executor
      end
    end
  end
end