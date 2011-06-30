module ActsAsExecutor
  module Executor
    module Model
      module Actions
        def self.included base
          base.after_find :startup
          base.after_save :startup

          base.after_destroy :shutdown, :if => :shutdown_now?
        end

        def shutdown
          self.log.debug "Executor \"" + name + "\" shutting down..."
          begin
            self.executor.shutdown
          rescue Java::java.lang.RuntimePermission
            self.log.error "Executor \"" + name + "\" has experienced a RuntimePermission error"
          rescue Java::java.lang.SecurityException
            self.log.error "Executor \"" + name + "\" has experienced a SecurityException error"
          end
          self.log.info "Executor \"" + name + "\" has completed shutdown"
        end

        def execute clazz, schedule, start, every, units
          begin
            if schedulable?
              units = Java::java.util.concurrent.TimeUnit.value_of(units.upcase)
              case schedule
                when ActsAsExecutor::Task::Schedules::ONE_SHOT
                  future = self.executor.schedule clazz, start, units
                when ActsAsExecutor::Task::Schedules::FIXED_DELAY
                  future = self.executor.schedule_with_fixed_delay clazz, start, every, units
                when ActsAsExecutor::Task::Schedules::FIXED_RATE
                  future = self.executor.schedule_at_fixed_rate clazz, start, every, units
              end
            else
              future = ActsAsExecutor::Common::FutureTask.new clazz, nil
              self.executor.execute future
            end
            return future
          rescue Java::java.lang.NullPointerException => e
            self.log.error "Executor \"" + name + "\" attaching task threw a NullPointerException. " + e.to_s
          rescue Java::java.lang.IllegalArgumentException => e
            self.log.error "Executor \"" + name + "\" attaching task threw a IllegalArgumentException. " + e.to_s
          rescue Java::java.util.concurrent.RejectedExecutionException => e
            self.log.error "Executor \"" + name + "\" attaching task threw a RejectedExecutionException. " + e.to_s
          end
        end

        private
        def startup
          if startup_now?
            self.log.debug "\"" + name + "\" executor startup triggered"
            self.executor = ActsAsExecutor::Executor::Factory.create kind, size
            self.log.info "\"" + name + "\" executor started"

            tasks.all
          else
            self.log.warn "\"" + name + "\" executor startup triggered but has already been started"
          end
        end
      end
    end
  end
end