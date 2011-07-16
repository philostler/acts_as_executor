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
        def execute instance, schedule, start, every, units
          begin
            self.log.debug "\"" + name + "\" executor enqueuing task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" for execution"

            if schedulable?
              units = Java::java.util.concurrent.TimeUnit.value_of(units.upcase)
              case schedule
                when ActsAsExecutor::Task::Schedules::ONE_SHOT
                  future = self.executor.schedule instance, start, units
                  self.log.debug "\"" + name + "\" executor enqueued task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" for execution (one shot)"
                when ActsAsExecutor::Task::Schedules::FIXED_DELAY
                  future = self.executor.schedule_with_fixed_delay instance, start, every, units
                  self.log.debug "\"" + name + "\" executor enqueued task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" for execution (fixed delay)"
                when ActsAsExecutor::Task::Schedules::FIXED_RATE
                  future = self.executor.schedule_at_fixed_rate instance, start, every, units
                  self.log.debug "\"" + name + "\" executor enqueued task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" for execution (fixed rate)"
              end
            else
              future = ActsAsExecutor::Common::FutureTask.new instance, nil
              self.executor.execute future
              self.log.debug "\"" + name + "\" executor enqueued task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" for execution"
            end

            future
          rescue Java::java.util.concurrent.RejectedExecutionException => exception
            self.log.warn "\"" + name + "\" executor enqueuing task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" experienced a rejected execution exception error"
          rescue Exception => exception
            self.log.error "\"" + name + "\" executor enqueuing task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" experienced an exception error. " + exception
          end
        end
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
          rescue Java::java.lang.SecurityException
            self.log.error "\"" + name + "\" executor experienced a security exception error during shutdown (forced)"
            self.log.fatal "\"" + name + "\" executor shutdown (forced) failed"
          else
            self.log.info "\"" + name + "\" executor shutdown (forced)"
          ensure
            self.executor = nil
          end
        end
      end
    end
  end
end