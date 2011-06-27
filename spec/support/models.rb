define_executor_model_class("Executor").acts_as_executor
define_executor_model_class("ExecutorWithoutExtension")

define_executor_task_model_class("ExecutorTask").acts_as_executor_task
define_executor_task_model_class("ExecutorTaskWithoutExtension")

class Rails
  def self.logger
    @@logger ||= nil
  end
  def self.logger= logger
    @@logger = logger
  end
end