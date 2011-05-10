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
            case @executor
              when Java::java.util.concurrent.ScheduledExecutorService
                unit = Java::java.util.concurrent.TimeUnit.value_of(task.unit.upcase)
                case task.schedule
                  when ActsAsExecutor::Model::Task::Schedules::ONE_SHOT
                    @executor.schedule clazz, task.start, unit
                  when ActsAsExecutor::Model::Task::Schedules::FIXED_DELAY
                    @executor.schedule_with_fixed_delay clazz, task.start, task.every, unit
                  when ActsAsExecutor::Model::Task::Schedules::FIXED_RATE
                    @executor.schedule_at_fixed_rate clazz, task.start, task.every, unit
                end
              when Java::java.util.concurrent.ExecutorService
                @executor.submit clazz
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
          unless @executor
            ActsAsExecutor.log.debug "Executor \"" + name + "\" starting up..."
            @executor = ActsAsExecutor::Model::Executor::Factory.create kind, size
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
          if @executor
            ActsAsExecutor.log.debug "Executor \"" + name + "\" shutting down..."
            begin
              @executor.shutdown
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