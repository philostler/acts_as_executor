module ActsAsExecutor
  module Task
    module Model
      module Actions
        def self.included base
          base.serialize :arguments, Hash

          base.after_find :execute, :if => :execute_now?
          base.after_save :execute, :if => :execute_now?
        end

        def execute
          begin
            instance = clazz.constantize.new
          rescue NameError
            ActsAsExecutor.log.error "Task creating task could not create class"
          end

          if arguments
            arguments.each_pair do |k, v|
              attribute = "#{k}="
              instance.send attribute, v if instance.respond_to? attribute
            end
          end

          self.future = executor.execute instance, schedule, start, every, units
          if !executor.schedulable?
            self.future.task = self
          end
        end
      end
    end
  end
end