module ActsAsExecutor
  module Model
    module Task
      module Base
        def acts_as_executor_task
          send :include, ActsAsExecutor::Model::Task::Associations
          send :include, ActsAsExecutor::Model::Task::Validations
        end
      end
    end
  end
end