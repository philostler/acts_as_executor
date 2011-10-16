module ActsAsExecutor
  module Task
    class Task
      include Java::java.lang.Runnable

      attr_accessor :arguments
      attr_writer :before_execute_handler, :after_execute_handler, :uncaught_exception_handler

      private
      def run
        begin
          @before_execute_handler.call if @before_execute_handler
          if @arguments
            @arguments.each_pair do |key, value|
              class_eval { attr_accessor key } unless respond_to? key
              send "#{key}=", value
            end
          end

          execute
        rescue Exception => exception
          @uncaught_exception_handler.call exception if @uncaught_exception_handler
        ensure
          @after_execute_handler.call if @after_execute_handler
        end
      end
    end
  end
end