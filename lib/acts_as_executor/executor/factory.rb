module ActsAsExecutor
  module Executor
    class Factory
      def self.create limit
        executor = nil
        if limit.nil?
          executor = Java::java.util.concurrent.Executors.new_cached_thread_pool
        else
          executor = Java::java.util.concurrent.Executors.new_scheduled_thread_pool limit.to_i
        end
        executor
      end
    end
  end
end