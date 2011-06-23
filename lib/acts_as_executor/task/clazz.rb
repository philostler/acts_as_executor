module ActsAsExecutor
  module Task
    module Clazz
      include Java::java.lang.Runnable

      private
      def run
        execute
      end
    end
  end
end