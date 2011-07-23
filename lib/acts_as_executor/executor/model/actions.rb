module ActsAsExecutor
  module Executor
    module Model
      module Actions
        def self.included base
          base.after_find :startup, :if => :can_startup?
          base.after_save :startup, :if => :can_startup?

          base.after_destroy :shutdown, :if => :can_shutdown?
        end

        private
        def startup
          log.debug log_message "startup triggered"
          self.executor = ActsAsExecutor::Executor::Factory.create kind, size
          log.info log_message "started"

          tasks.all
        end

        def execute clazz, schedule = nil, start = nil, every = nil, units = nil
          begin
            humanized_schedule = schedule ? schedule.gsub("_", " ") : "one time"
            log.debug log_message_with_task "enqueuing", clazz, "for execution (" + humanized_schedule + ")"

            if schedulable?
              units = Java::java.util.concurrent.TimeUnit.value_of(units.upcase)
              case schedule
                when ActsAsExecutor::Task::Schedules::ONE_SHOT
                  future = executor.schedule clazz, start, units
                when ActsAsExecutor::Task::Schedules::FIXED_DELAY
                  future = executor.schedule_with_fixed_delay clazz, start, every, units
                when ActsAsExecutor::Task::Schedules::FIXED_RATE
                  future = executor.schedule_at_fixed_rate clazz, start, every, units
              end
            else
              future = ActsAsExecutor::Common::FutureTask.new clazz, nil
              executor.execute future
            end

            log.info log_message_with_task "enqueued", clazz, "for execution (" + humanized_schedule + ")"
            future
          rescue Java::java.util.concurrent.RejectedExecutionException
            log.warn log_message_with_task "enqueuing", clazz,  "encountered a rejected execution exception"
          rescue Exception => exception
            log.error log_message_with_task "enqueuing", clazz,  "encountered an unexpected exception. " + exception
          end
        end

        def shutdown
          log.debug log_message "shutdown triggered"
          begin
            executor.shutdown
          rescue Java::java.lang.SecurityException
            log.warn log_message "shutdown encountered a security exception"
            forced_shutdown
          else
            log.info log_message "shutdown"
          ensure
            self.executor = nil
          end
        end

        def forced_shutdown
          log.debug log_message "forced shutdown triggered"
          begin
            executor.shutdown_now
          rescue Java::java.lang.SecurityException
            log.error log_message "forced shutdown encountered a security exception"
            log.fatal log_message "forced shutdown failure"
          else
            log.info log_message "forced shutdown"
          ensure
            self.executor = nil
          end
        end
      end
    end
  end
end