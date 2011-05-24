module ActsAsExecutor
  module Executor
    module Model
      module Base
        def acts_as_executor
          send :include, ActsAsExecutor::Executor::Model::Actions
          send :include, ActsAsExecutor::Executor::Model::Associations
          send :include, ActsAsExecutor::Executor::Model::Attributes
          send :include, ActsAsExecutor::Executor::Model::Helpers
          send :include, ActsAsExecutor::Executor::Model::Validations

          if ActsAsExecutor.rails_startup?
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
end