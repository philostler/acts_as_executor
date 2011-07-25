# Rails
Object.const_set "Rails", Class.new

# Logger
class Logger
  def debug message = nil, &block; end
  def info message = nil, &block; end
  def warn message = nil, &block; end
  def error message = nil, &block; end
  def fatal message = nil, &block; end
end

# Executor
Object.const_set "Executor", Class.new(ActiveRecord::Base)
ActiveRecord::Schema.define do
  self.verbose = false

  create_table :executors, :force => true do |t|
    t.string  :name
    t.string  :kind
    t.integer :size
  end
end
Executor.acts_as_executor
Executor.log = Logger.new

# ExecutorWithoutActsAsExecutor
Object.const_set "ExecutorWithoutActsAsExecutor", Class.new(ActiveRecord::Base)

# ExecutorTask
Object.const_set "ExecutorTask", Class.new(ActiveRecord::Base)
ActiveRecord::Schema.define do
  self.verbose = false

  create_table :executor_tasks, :force => true do |t|
    t.integer  :executor_id
    t.string   :clazz
    t.string   :arguments
    t.string   :schedule
    t.integer  :start
    t.integer  :every
    t.string   :units
  end
end
ExecutorTask.acts_as_executor_task

# Clazz
Object.const_set "Clazz", Class.new
Clazz.send :extend, Machinist::Machinable
Clazz.send :include, ActsAsExecutor::Task::Clazz