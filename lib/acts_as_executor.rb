require "acts_as_executor/model/executor/base"
require "acts_as_executor/model/executor/factory"
require "acts_as_executor/model/executor/instance_methods"
require "acts_as_executor/model/executor/kinds"
require "acts_as_executor/model/executor/validations"

ActiveRecord::Base.send :extend, ActsAsExecutor::Model::Executor::Base

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