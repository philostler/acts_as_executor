module ActsAsExecutor
  module Task
    class Executable
      include Java::java.lang.Runnable

      attr_accessor :arguments
      attr_writer :uncaught_exception_handler

      private
      def run
        begin
          if @arguments
            @arguments.each_pair do |key, value|
              class_eval { attr_accessor key } unless respond_to? key
              send "#{key}=", value
            end
          end

          execute
        rescue Exception => exception
          @uncaught_exception_handler.call exception if @uncaught_exception_handler
        end
      end
    end
  end
end