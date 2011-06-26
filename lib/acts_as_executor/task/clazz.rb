module ActsAsExecutor
  module Task
    module Clazz
      include Java::java.lang.Runnable

      attr_writer :arguments

      private
      def run
        if @arguments
          @arguments.each_pair do |k, v|
            class_eval { attr_accessor k }
            send "#{k}=", v
          end
        end

        execute
      end
    end
  end
end