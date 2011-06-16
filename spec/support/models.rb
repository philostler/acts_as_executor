class Rails
  def self.logger
    @@logger
  end
  def self.logger= logger
    @@logger = logger
  end
end

class Executor < ActiveRecord::Base
  acts_as_executor
end

class ExecutorWithoutExtension < ActiveRecord::Base
end