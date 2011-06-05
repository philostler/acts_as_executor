module ActsAsExecutor
  module Task
    module Model
      module Attributes
        @@futures = Hash.new

        def future
          @@futures[id]
        end
        def future= future
          @@futures[id] = future
        end
      end
    end
  end
end