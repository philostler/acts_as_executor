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

          # Validations
          base.validates :name, :presence => true, :uniqueness => true
          base.validates :max_tasks, :presence => true, :if => :schedulable?
          base.validates :max_tasks, :numericality => { :only_integer => true, :greater_than_or_equal_to => 1 }, :allow_nil => true
        end

        private
        def startup
          log.debug log_statement name, "startup triggered"
          self.executor = ActsAsExecutor::Executor::Factory.create max_tasks, schedulable
          log.info log_statement name, "started"

          tasks.all
        end

        def execute instance, task_id, schedule = nil, start = nil, every = nil
          begin
            humanized_schedule = schedule ? schedule.gsub("_", " ") : "one time"
            log.debug log_message name, "preparing", task_id, instance.class.name, "for execution (" + humanized_schedule + ")"

            if schedulable?
              units = Java::java.util.concurrent.TimeUnit::SECONDS
              case schedule
                when ActsAsExecutor::Task::Schedules::ONE_SHOT
                  future = executor.schedule instance, start, units
                when ActsAsExecutor::Task::Schedules::FIXED_DELAY
                  future = executor.schedule_with_fixed_delay instance, start, every, units
                when ActsAsExecutor::Task::Schedules::FIXED_RATE
                  future = executor.schedule_at_fixed_rate instance, start, every, units
              end
            else
              future = ActsAsExecutor::Common::FutureTask.new instance, nil
              executor.execute future
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