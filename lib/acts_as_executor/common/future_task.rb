module ActsAsExecutor
  module Common
    class FutureTask < Java::java.util.concurrent.FutureTask
      attr_writer :done_handler

      def done
        @done_handler.call if @done_handler
      end
    end
  end
end