require "acts_as_executor/model/executor/associations"
require "acts_as_executor/model/executor/base"
require "acts_as_executor/model/executor/factory"
require "acts_as_executor/model/executor/instance_methods"
require "acts_as_executor/model/executor/kinds"
require "acts_as_executor/model/executor/validations"

require "acts_as_executor/model/task/associations"
require "acts_as_executor/model/task/base"
require "acts_as_executor/model/task/validations"

require "acts_as_executor/validators/class_exists_validator"

ActiveRecord::Base.send :extend, ActsAsExecutor::Model::Executor::Base
ActiveRecord::Base.send :extend, ActsAsExecutor::Model::Task::Base

module ActsAsExecutor
  def self.log
    logger
  end
  def self.logger
    @@logger ||= Rails.logger
  end
  def self.logger= logger
    @@logger = logger
  end
end