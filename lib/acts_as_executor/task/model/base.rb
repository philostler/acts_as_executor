module ActsAsExecutor
  module Task
    module Model
      module Base
        def acts_as_executor_task
          send :include, ActsAsExecutor::Task::Model::Associations
          send :include, ActsAsExecutor::Task::Model::Actions
          send :include, ActsAsExecutor::Task::Model::Validations
        end
      end
    end
  end
end