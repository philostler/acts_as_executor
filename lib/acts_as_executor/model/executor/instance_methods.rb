module ActsAsExecutor
  module Model
    module Executor
      module InstanceMethods
        def self.included base
          base.after_destroy :shutdown
          base.after_find :startup
          base.after_save :startup
          base.after_update :update
        end

        protected
        @@executors = Hash.new

        def executor
          @@executors[id]
        end

        private
        def executor= executor
          @@executors[id] = executor
        end

        def shutdown
          unless self.executor
            p "SHUTDOWN"
          end
        end

        def startup
          unless self.executor
            p "STARTUP"
            self.executor = true
          end
        end

        def update
          p "UPDATE"
        end
      end
    end
  end
end