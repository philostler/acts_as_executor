module ActsAsExecutor
  module Task
    module Model
      module InstanceMethods
        def self.included base
          # Associations
          base.belongs_to :executor, :class_name => base.table_name.sub(/_tasks/, "").camelize

          # Callbacks
          base.after_find :enqueue, :if => :enqueueable?
          base.after_save :enqueue, :if => :enqueueable?
          base.after_destroy :cancel, :if => :cancelable?

          # Scopes
          base.scope :active, base.where("completed_at IS NULL")
          base.scope :complete, base.where("completed_at IS NOT NULL")
          base.scope :single, base.where("every IS NULL")
          base.scope :scheduled, base.where("every IS NOT NULL")

          # Serialization
          base.serialize :arguments, Hash

          # Validations
          base.validates :executor_id, :presence => true
          base.validates :task, :presence => true, :class_exists => true, :class_subclasses => { :superclass => ActsAsExecutor::Task::Task }
          base.validates :start, :presence => true, :if => "!every.nil?"
          base.validates :start, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }, :allow_nil => true
          base.validates :every, :numericality => { :only_integer => true, :greater_than_or_equal_to => 1 }, :allow_nil => true
        end

        private
        def enqueue
          begin
            executor.send(:log).debug log_message executor.name, "creating", id.to_s, task, arguments

            instance = instantiate task, arguments

            self.future = executor.send(:execute, instance, id.to_s, start, every, every_strict)
          rescue RuntimeError => exception
            executor.send(:log).error log_message executor.name, "creating", id.to_s, task, "encountered an unexpected exception. " + exception.to_s
          end
        end

        def instantiate class_name, arguments
          instance = Object.const_get(class_name).new
          instance.arguments = arguments

          instance.before_execute_handler = Proc.new {
            executor.send(:log).debug log_message executor.name, "started", id.to_s, task
            update_attribute :started_at, Time.now
          }

          instance.after_execute_handler = Proc.new {
            executor.send(:log).debug log_message executor.name, "completed", id.to_s, task
            update_attribute :completed_at, Time.now
          }

          instance.uncaught_exception_handler = Proc.new {
            executor.send(:log).error log_message executor.name, "executing", id.to_s, task, "encountered an uncaught exception. " + exception.to_s
          }

          instance
        end

        def cancel
          future.cancel true
          self.future = nil
        end
      end
    end
  end
end