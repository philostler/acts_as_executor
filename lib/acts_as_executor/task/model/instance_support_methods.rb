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

        def enqueueable?
          if future == nil
            return true
          end
          return false
        end

        def cancelable?
          if future != nil
            return true
          end
          return false
        end

        def log_message doing, message
          "\"" + executor.name + "\" executor " + doing + " task \"" + clazz + "\" with arguments \"" + arguments.inspect + "\" " + message
        end
      end
    end
  end
end