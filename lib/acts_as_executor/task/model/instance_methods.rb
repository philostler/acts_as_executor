module ActsAsExecutor
  module Task
    module Model
      module InstanceMethods
        def self.included base
          # Associations
          base.belongs_to :executor, :class_name => base.table_name.sub(/_tasks/, "").camelize

          # Callbacks
          base.after_find :enqueue, :if => :enqueue_able?
          base.after_save :enqueue, :if => :enqueue_able?
          base.after_destroy :cancel, :if => :cancel_able?

          # Serialization
          base.serialize :arguments, Hash

          # Validations
          base.validates :executor_id, :presence => true
          base.validates :clazz, :presence => true, :class_exists_with_required_module => true
          base.validates :schedule, :inclusion => { :in => ActsAsExecutor::Task::Schedules::ALL }, :if => "executor and executor.schedulable?"
          base.validates :start, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }, :if => "executor and executor.schedulable?"
          base.validates :every, :numericality => { :only_integer => true, :greater_than_or_equal_to => 1 }, :if => "executor and executor.schedulable? and schedule != ActsAsExecutor::Task::Schedules::ONE_SHOT"
          base.validates :units, :inclusion => { :in => ActsAsExecutor::Common::Units::ALL }, :if => "executor and executor.schedulable?"
        end

        private
        def enqueue
          begin
            self.log.debug "\"" + executor.name + "\" executor instantiating task \"" + clazz + "\" with arguments \"" + arguments.inspect + "\" for execution"

            instance = instantiate clazz, arguments

            self.future = executor.send(:execute, instance, schedule, start, every, units)
            self.future.done_handler = method :done_handler
          rescue Exception => exception
            executor.send(:log).error "\"" + executor.name + "\" executor instantiating task \"" + clazz + "\" with arguments \"" + arguments.inspect + "\" experienced an exception error. " + exception
          end
        end

        def instantiate class_name, arguments
          instance = Object.const_get(class_name).new
          instance.arguments = arguments
          instance.uncaught_exception_handler = method :uncaught_exception_handler
          instance
        end

        def cancel
          if self.future.cancel true
            # success
          else
            # failed
          end

          self.future = nil
        end

        def done_handler
          destroy
        end

        def uncaught_exception_handler exception
          executor.send(:log).error "\"" + executor.name + "\" executor executing task \"" + clazz + "\" experienced an uncaught exception. " + exception
        end
      end
    end
  end
end