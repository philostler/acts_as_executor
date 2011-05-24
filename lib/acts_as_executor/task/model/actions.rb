module ActsAsExecutor
  module Task
    module Model
      module Actions
        def self.included base
          base.serialize :arguments, Hash
        end
      end
    end
  end
end