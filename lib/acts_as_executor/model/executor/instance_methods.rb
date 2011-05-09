module ActsAsExecutor
  module Model
    module Executor
      module InstanceMethods
        def self.included base
          base.after_find :startup
          base.after_save :startup
          base.after_update :update
          base.after_destroy :shutdown
        end

        def schedulable?
          ActsAsExecutor::Model::Executor::Kinds::ALL_SCHEDULED.include? kind
        end

        @@executors = Hash.new

        def executor
          @@executors[id]
        end
        def executor= executor
          @@executors[id] = executor
        end

        def submit task
          clazz = task.clazz.constantize.new

          begin
            case self.executor
              when Java::java.util.concurrent.ScheduledExecutorService
                unit = Java::java.util.concurrent.TimeUnit.value_of(task.unit.upcase)
                case task.schedule
                  when ActsAsExecutor::Model::Task::Schedules::ONE_SHOT
                    self.executor.schedule clazz, task.start, unit
                  when ActsAsExecutor::Model::Task::Schedules::FIXED_DELAY
                    self.executor.schedule_with_fixed_delay clazz, task.start, task.every, unit
                  when ActsAsExecutor::Model::Task::Schedules::FIXED_RATE
                    self.executor.schedule_at_fixed_rate clazz, task.start, task.every, unit
                end
              when Java::java.util.concurrent.ExecutorService
                self.executor.submit clazz
            end
          rescue Java::java.lang.NullPointerException
            ActsAsExecutor.log.error "Executor \"" + name + "\" attaching task \"" + task.clazz + "\" threw a NullPointerException"
          rescue Java::java.lang.IllegalArgumentException
            ActsAsExecutor.log.error "Executor \"" + name + "\" attaching task \"" + task.clazz + "\" threw a IllegalArgumentException"
          rescue Java::java.util.concurrent.RejectedExecutionException
            ActsAsExecutor.log.error "Executor \"" + name + "\" attaching task \"" + task.clazz + "\" threw a RejectedExecutionException"
          end
        end
        
        def startup
          unless self.executor
            ActsAsExecutor.log.debug "Executor \"" + name + "\" starting up..."
            self.executor = ActsAsExecutor::Model::Executor::Factory.create kind, size
            ActsAsExecutor.log.info "Executor \"" + name + "\" has completed startup"
            
            ActsAsExecutor.log.debug "Executor \"" + name + "\" attaching tasks..."
            tasks.each do |t|
              submit t
            end
            ActsAsExecutor.log.info "Executor \"" + name + "\" has completed attaching tasks"
          end
        end

        def update
          ActsAsExecutor.log.info "UPDATE"
        end

        def shutdown
          if self.executor
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
        end
      end
    end
  end
end