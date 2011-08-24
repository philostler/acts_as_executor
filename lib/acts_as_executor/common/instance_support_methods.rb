module ActsAsExecutor
  module Common
    module InstanceSupportMethods
      private
      def log_statement executor_name, statement
        "\"" + executor_name + "\" " + statement
      end

      def log_message executor_name, doing, task_id, clazz_name, message = ""
        if message.kind_of? Hash then message = "with \"" + message.inspect + "\"" end 
        "\"" + executor_name + "\" " + doing + " \"" + task_id + "#" + clazz_name + "\" " + message
      end
    end
  end
end