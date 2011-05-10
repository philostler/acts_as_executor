module ActsAsExecutor
  module Model
    module Task
      module InstanceMethods
        def self.included base
          base.serialize :arguments, Hash
        end
      end
    end
  end
end