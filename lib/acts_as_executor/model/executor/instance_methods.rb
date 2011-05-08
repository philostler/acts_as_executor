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

        def startup
          unless self.executor
            ActsAsExecutor.log.debug "Executor \"" + name + "\" starting up..."
            self.executor = ActsAsExecutor::Model::Executor::Factory.create kind, size
            ActsAsExecutor.log.info "Executor \"" + name + "\" has completed startup"
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