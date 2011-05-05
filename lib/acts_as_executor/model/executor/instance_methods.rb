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

        @@executors = Hash.new

        def executor
          @@executors[id]
        end
        def executor= executor
          @@executors[id] = executor
        end

        def startup
          unless self.executor
            ActsAsExecutor.log.info "STARTUP"
            self.executor = ActsAsExecutor::Model::Executor::Factory.create kind, size
          end
        end

        def update
          ActsAsExecutor.log.info "UPDATE"
        end

        def shutdown
          if self.executor
            ActsAsExecutor.log.info "SHUTDOWN"
            begin
              self.executor.shutdown
            rescue Java::java.lang.RuntimePermission
              ActsAsExecutor.log.info "RuntimePermission"
            rescue Java::java.lang.SecurityException
              ActsAsExecutor.log.info "SecurityException"
            end
          end
        end
      end
    end
  end
end