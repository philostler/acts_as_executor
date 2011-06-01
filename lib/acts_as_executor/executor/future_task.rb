module ActsAsExecutor
  module Executor
    class FutureTask < Java::java.util.concurrent.FutureTask
      attr_accessor :task

      def done
       task.destroy
      end
    end
  end
end