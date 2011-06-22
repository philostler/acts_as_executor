double_executor_model("Executor").acts_as_executor
double_executor_model("ExecutorWithoutExtension")

double_executor_task_model("ExecutorTask").acts_as_executor_task
double_executor_task_model("ExecutorTaskWithoutExtension")

class Rails
  def self.logger
    @@logger ||= nil
  end
  def self.logger= logger
    @@logger = logger
  end
end