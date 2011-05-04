require "acts_as_executor/model/executor/base"
require "acts_as_executor/model/executor/instance_methods"

ActiveRecord::Base.send :extend, ActsAsExecutor::Model::Executor::Base