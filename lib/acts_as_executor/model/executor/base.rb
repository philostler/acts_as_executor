module ActsAsExecutor
  module Model
    module Executor
      module Base
        def acts_as_executor
          send :include, ActsAsExecutor::Model::Executor::InstanceMethods

          all
        end
      end
    end
  end
end