module ActsAsExecutor
  module Task
    module Model
      module InstanceSupportMethods
        private
        @@futures = Hash.new
        def future
          @@futures[id]
        end

        def future= future
          raise ArgumentError, "cannot reference future against nil id" unless id
          @@futures[id] = future
        end

        def enqueue_able?
          if future == nil
            return true
          end
          return false
        end

        def cancel_able?
          if future != nil
            return true
          end
          return false
        end
      end
    end
  end
end