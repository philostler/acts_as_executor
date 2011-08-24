module ActsAsExecutor
  module Executor
    module Model
      module InstanceSupportMethods
        private
        @@executors = Hash.new
        def executor
          @@executors[id]
        end

        def executor= executor
          raise ArgumentError, "cannot reference executor against nil id" unless id
          @@executors[id] = executor
        end

        def startupable?
          if executor == nil && ActsAsExecutor.rails_initialized?
            return true
          end
          return false
        end

        def shutdownable?
          if executor != nil && ActsAsExecutor.rails_initialized?
            return true
          end
          return false
        end

        def log
          self.class.log
        end
      end
    end
  end
end