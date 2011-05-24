module ActsAsExecutor
  module Executor
    module Model
      module Associations
        def self.included base
          base.has_many :tasks, :class_name => base.table_name.singularize.camelize + "Task", :foreign_key => "executor_id"
        end
      end
    end
  end
end