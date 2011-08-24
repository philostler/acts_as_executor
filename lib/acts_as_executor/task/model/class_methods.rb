module ActsAsExecutor
  module Task
    module Model
      module ClassMethods
        def acts_as_executor_task
          send :include, ActsAsExecutor::Common::InstanceSupportMethods
          send :include, ActsAsExecutor::Task::Model::InstanceMethods
          send :include, ActsAsExecutor::Task::Model::InstanceSupportMethods
        end
      end
    end
  end
end