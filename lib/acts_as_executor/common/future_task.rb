module ActsAsExecutor
  module Common
    class FutureTask < Java::java.util.concurrent.FutureTask
      attr_accessor :task

      def done
       task.destroy
      end
    end
  end
end