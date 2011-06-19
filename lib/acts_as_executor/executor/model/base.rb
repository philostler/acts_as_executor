module ActsAsExecutor
  module Executor
    module Model
      module Base
        def acts_as_executor *arguments
          send :include, ActsAsExecutor::Executor::Model::Actions
          send :include, ActsAsExecutor::Executor::Model::Associations
          send :include, ActsAsExecutor::Executor::Model::Attributes
          send :include, ActsAsExecutor::Executor::Model::Helpers
          send :extend, ActsAsExecutor::Executor::Model::Logging
          send :include, ActsAsExecutor::Executor::Model::Validations

          hash = arguments.last.is_a?(Hash) ? arguments.pop : {}
          self.logger = hash[:logger]

          if ActsAsExecutor.rails_booted?
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