module ActsAsExecutor
  module Model
    module Executor
      module Base
        def acts_as_executor
          send :include, ActsAsExecutor::Model::Executor::Associations
          send :include, ActsAsExecutor::Model::Executor::InstanceMethods
          send :include, ActsAsExecutor::Model::Executor::Validations

          all
          at_exit do
            all.each do |e|
              e.shutdown
            end
          end
        end
      end
    end
  end
end