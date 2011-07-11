module ActsAsExecutor
  module Task
    module Clazz
      include Java::java.lang.Runnable

      attr_writer :arguments, :uncaught_exception_handler

      private
      def run
        if @arguments
          @arguments.each_pair do |k, v|
            class_eval { attr_accessor k } unless respond_to? k
            send "#{k}=", v
          end
        end

        begin
          execute
        rescue Exception => exception
          @uncaught_exception_handler.call exception
        end
      end
    end
  end
end