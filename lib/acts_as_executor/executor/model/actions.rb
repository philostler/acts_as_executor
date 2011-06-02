module ActsAsExecutor
  module Executor
    module Model
      module Actions
        def self.included base
          base.after_find :startup, :if => :startup_now?
          base.after_save :startup, :if => :startup_now?

          base.after_destroy :shutdown, :if => :shutdown_now?
        end

        def startup
          ActsAsExecutor.log.debug "Executor \"" + name + "\" starting up..."
          self.executor = ActsAsExecutor::Executor::Factory.create kind, size
          ActsAsExecutor.log.info "Executor \"" + name + "\" has completed startup"
          
          ActsAsExecutor.log.debug "Executor \"" + name + "\" attaching tasks..."
          tasks.each do |t|
            submit t
          end
          ActsAsExecutor.log.info "Executor \"" + name + "\" has completed attaching tasks"
        end

        def shutdown
          ActsAsExecutor.log.debug "Executor \"" + name + "\" shutting down..."
          begin
            self.executor.shutdown
          rescue Java::java.lang.RuntimePermission
            ActsAsExecutor.log.error "Executor \"" + name + "\" has experienced a RuntimePermission error"
          rescue Java::java.lang.SecurityException
            ActsAsExecutor.log.error "Executor \"" + name + "\" has experienced a SecurityException error"
          end
          ActsAsExecutor.log.info "Executor \"" + name + "\" has completed shutdown"
        end

        def submit task
          begin
            clazz = task.clazz.constantize.new
          rescue NameError
            ActsAsExecutor.log.error "Executor \"" + name + "\" attaching task \"" + task.clazz + "\" could not create class"            
          end

          if task.arguments
            task.arguments.each_pair do |k, v|
              attribute = "#{k}="
              clazz.send attribute, v if clazz.respond_to? attribute
            end
          end

          begin
            if schedulable?
              units = Java::java.util.concurrent.TimeUnit.value_of(task.units.upcase)
              case task.schedule
                when ActsAsExecutor::Task::Schedules::ONE_SHOT
                  self.executor.schedule clazz, task.start, units
                when ActsAsExecutor::Task::Schedules::FIXED_DELAY
                  self.executor.schedule_with_fixed_delay clazz, task.start, task.every, units
                when ActsAsExecutor::Task::Schedules::FIXED_RATE
                  self.executor.schedule_at_fixed_rate clazz, task.start, task.every, units
              end
            else
              case clazz
                when Java::java.util.concurrent.Callable
                  future_task = ActsAsExecutor::Executor::FutureTask.new clazz
                when Java::java.lang.Runnable
                  future_task = ActsAsExecutor::Executor::FutureTask.new clazz, nil
              end
              future_task.task = task
              self.executor.execute future_task
            end
          rescue Java::java.lang.NullPointerException
            ActsAsExecutor.log.error "Executor \"" + name + "\" attaching task \"" + task.clazz + "\" threw a NullPointerException"
          rescue Java::java.lang.IllegalArgumentException
            ActsAsExecutor.log.error "Executor \"" + name + "\" attaching task \"" + task.clazz + "\" threw a IllegalArgumentException"
          rescue Java::java.util.concurrent.RejectedExecutionException
            ActsAsExecutor.log.error "Executor \"" + name + "\" attaching task \"" + task.clazz + "\" threw a RejectedExecutionException"
          end
        end
      end
    end
  end
end