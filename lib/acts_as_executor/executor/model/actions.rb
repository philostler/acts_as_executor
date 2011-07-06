module ActsAsExecutor
  module Executor
    module Model
      module Actions
        def self.included base
          base.after_find :startup, :if => :can_startup?
          base.after_save :startup, :if => :can_startup?

          base.after_destroy :shutdown, :if => :can_shutdown?
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
          self.log.debug "\"" + name + "\" executor startup triggered"
          self.executor = ActsAsExecutor::Executor::Factory.create kind, size
          self.log.info "\"" + name + "\" executor started"

          tasks.all
        end
        def shutdown
          self.log.debug "\"" + name + "\" executor shutdown triggered"
          begin
            self.executor.shutdown
          rescue Java::java.lang.RuntimePermission
            self.log.warn "\"" + name + "\" executor experienced a runtime permission error during shutdown"
            shutdown_forced
          rescue Java::java.lang.SecurityException
            self.log.warn "\"" + name + "\" executor experienced a security exception error during shutdown"
            shutdown_forced
          else
            self.log.info "\"" + name + "\" executor shutdown"
          ensure
            self.executor = nil
          end
        end
        def shutdown_forced
          self.log.debug "\"" + name + "\" executor shutdown (forced) triggered"
          begin
            self.executor.shutdown_now
          rescue Java::java.lang.RuntimePermission
            self.log.error "\"" + name + "\" executor experienced a runtime permission error during shutdown (forced)"
            self.log.fatal "\"" + name + "\" executor shutdown (forced) failed"
          rescue Java::java.lang.SecurityException
            self.log.error "\"" + name + "\" executor experienced a security exception error during shutdown (forced)"
            self.log.fatal "\"" + name + "\" executor shutdown (forced) failed"
          else
            self.log.info "\"" + name + "\" executor shutdown (forced)"
          end
        end
      end
    end
  end
end