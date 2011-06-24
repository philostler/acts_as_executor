require "active_model"
require "active_record"

require "acts_as_executor/common/future_task"
require "acts_as_executor/common/units"

require "acts_as_executor/executor/factory"
require "acts_as_executor/executor/kinds"

require "acts_as_executor/executor/model/actions"
require "acts_as_executor/executor/model/associations"
require "acts_as_executor/executor/model/attributes"
require "acts_as_executor/executor/model/base"
require "acts_as_executor/executor/model/helpers"
require "acts_as_executor/executor/model/logging"
require "acts_as_executor/executor/model/validations"

require "acts_as_executor/task/clazz"
require "acts_as_executor/task/schedules"

require "acts_as_executor/task/model/actions"
require "acts_as_executor/task/model/associations"
require "acts_as_executor/task/model/attributes"
require "acts_as_executor/task/model/base"
require "acts_as_executor/task/model/helpers"
require "acts_as_executor/task/model/validations"

require "acts_as_executor/validators/class_exists_with_required_module_validator"

ActiveRecord::Base.send :extend, ActsAsExecutor::Executor::Model::Base
ActiveRecord::Base.send :extend, ActsAsExecutor::Task::Model::Base

module ActsAsExecutor
  def self.rails_booted?
    File.basename($0) == "rails"
  end
end