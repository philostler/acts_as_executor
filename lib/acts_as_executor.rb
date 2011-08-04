require "active_model"
require "active_record"

require "acts_as_executor/common/future_task"
require "acts_as_executor/common/units"

require "acts_as_executor/executor/factory"
require "acts_as_executor/executor/kinds"

require "acts_as_executor/executor/model/class_methods"
require "acts_as_executor/executor/model/instance_methods"
require "acts_as_executor/executor/model/instance_support_methods"

require "acts_as_executor/task/clazz"
require "acts_as_executor/task/schedules"

require "acts_as_executor/task/model/class_methods"
require "acts_as_executor/task/model/instance_methods"
require "acts_as_executor/task/model/instance_support_methods"

require "acts_as_executor/validators/class_exists_validator"
require "acts_as_executor/validators/class_includes_module_validator"

ActiveRecord::Base.send :extend, ActsAsExecutor::Executor::Model::ClassMethods
ActiveRecord::Base.send :extend, ActsAsExecutor::Task::Model::ClassMethods

module ActsAsExecutor
  def self.rails_booted?
    File.basename($0) == "rails"
  end
end