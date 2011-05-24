module ActsAsExecutor
  module Executor
    module Model
      module Attributes
        @@executors = Hash.new

        def executor
          @@executors[id]
        end
        def executor= executor
          @@executors[id] = executor
        end
      end
    end
  end
end