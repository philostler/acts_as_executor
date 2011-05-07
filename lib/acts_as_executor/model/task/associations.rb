module ActsAsExecutor
  module Model
    module Task
      module Associations
        def self.included base
          base.belongs_to :executor, :class_name => base.table_name.sub(/_tasks/, "").camelize
        end
      end
    end
  end
end