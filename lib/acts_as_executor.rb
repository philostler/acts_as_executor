require "active_model"
require "active_record"

require "acts_as_executor/version"

require "acts_as_executor/common/instance_support_methods"

require "acts_as_executor/executor/model/class_methods"
require "acts_as_executor/executor/model/instance_methods"
require "acts_as_executor/executor/model/instance_support_methods"

require "acts_as_executor/task/task"

require "acts_as_executor/task/model/class_methods"
require "acts_as_executor/task/model/instance_methods"
require "acts_as_executor/task/model/instance_support_methods"

require "acts_as_executor/validators/class_exists_validator"
require "acts_as_executor/validators/class_subclasses_validator"

ActiveRecord::Base.send :extend, ActsAsExecutor::Executor::Model::ClassMethods
ActiveRecord::Base.send :extend, ActsAsExecutor::Task::Model::ClassMethods

module ActsAsExecutor
  def self.rails_initialized?
    File.basename($0) != "rake"
  end
end