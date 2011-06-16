class Executor < ActiveRecord::Base
  acts_as_executor
end

class ExecutorWithoutExtension < ActiveRecord::Base
end