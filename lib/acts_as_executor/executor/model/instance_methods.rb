module ActsAsExecutor
  module Executor
    module Model
      module InstanceMethods
        def self.included base
          # Associations
          base.has_many :tasks, :class_name => base.table_name.singularize.camelize + "Task", :foreign_key => "executor_id"

          # Callbacks
          base.after_find :startup, :if => :startupable?
          base.after_save :startup, :if => :startupable?
          base.after_destroy :shutdown, :if => :shutdownable?
          base.before_save :synchronise_limit, :if => :limit_changed?

          # Validations
          base.validates :name, :presence => true, :uniqueness => true
          base.validates :limit, :presence => true, :numericality => { :only_integer => true, :greater_than_or_equal_to => 1 }
        end

        private
        def startup
          log.debug log_statement name, "startup triggered"
          self.executor = ActsAsExecutor::Executor::Factory.create limit
          log.info log_statement name, "started"

          tasks.all
        end

        def synchronise_limit
          executor.core_pool_size = limit
          log.info log_statement name, "limit synchronised (" + limit_was.to_s + " => " + limit.to_s + ")"
        end

        def execute instance, task_id, start = nil, every = nil, every_strict = false
          begin
            scheduled_task = !start.nil? || !every.nil?
            log.debug log_message name, "preparing", task_id, instance.class.name, "for execution" + (scheduled_task ? " (scheduled)" : "")

            if scheduled_task
              units = Java::java.util.concurrent.TimeUnit::SECONDS

              if every.nil?
                future = executor.schedule instance, start, units
              else
                if every_strict
                  future = executor.schedule_with_fixed_delay instance, start, every, units
                else
                  future = executor.schedule_at_fixed_rate instance, start, every, units
                end
              end
            else
              future = executor.submit instance
            end

            log.info log_message name, "enqueued", task_id, instance.class.name

            future
          rescue Java::java.util.concurrent.RejectedExecutionException
            log.warn log_message name, "preparing", task_id, instance.class.name, "encountered a rejected execution exception"
          rescue Exception => exception
            log.error log_message name, "preparing", task_id, instance.class.name, "encountered an unexpected exception. " + exception.to_s
          end
        end

        def shutdown
          log.debug log_statement name, "shutdown triggered"
          begin
            executor.shutdown
          rescue Java::java.lang.SecurityException
            log.warn log_statement name, "shutdown encountered a security exception"
            forced_shutdown
          else
            log.info log_statement name, "shutdown"
          ensure
            self.executor = nil
          end
        end

        def forced_shutdown
          log.debug log_statement name, "forced shutdown triggered"
          begin
            executor.shutdown_now
          rescue Java::java.lang.SecurityException
            log.error log_statement name, "forced shutdown encountered a security exception"
            log.fatal log_statement name, "forced shutdown failure"
          else
            log.info log_statement name, "forced shutdown"
          ensure
            self.executor = nil
          end
        end
      end
    end
  end
end