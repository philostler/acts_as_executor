module ActsAsExecutor
  module Executor
    class Factory
      def self.create kind, size = nil
        executor = nil
        case kind
          when ActsAsExecutor::Executor::Kinds::CACHED
            executor = create_cached
          when ActsAsExecutor::Executor::Kinds::FIXED
            executor = create_fixed size
          when ActsAsExecutor::Executor::Kinds::SINGLE
            executor = create_single
          when ActsAsExecutor::Executor::Kinds::SCHEDULED
            executor = create_scheduled size
          when ActsAsExecutor::Executor::Kinds::SINGLE_SCHEDULED
            executor = create_single_scheduled
        end
        executor
      end

      def self.create_cached
        Java::java.util.concurrent.Executors.new_cached_thread_pool
      end

      def self.create_fixed size
        raise TypeError, "size cannot be nil" unless size
        raise ArgumentError, "size must be larger than 0" unless size.to_i > 0
        Java::java.util.concurrent.Executors.new_fixed_thread_pool size.to_i
      end

      def self.create_single
        Java::java.util.concurrent.Executors.new_single_thread_executor
      end

      def self.create_scheduled size
          raise TypeError, "size cannot be nil" unless size
          raise ArgumentError, "size must be larger than 0" unless size.to_i > 0
          Java::java.util.concurrent.Executors.new_scheduled_thread_pool size.to_i
      end

      def self.create_single_scheduled
        Java::java.util.concurrent.Executors.new_single_thread_scheduled_executor
      end
    end
  end
end