double_executor_model("Executor").acts_as_executor
double_executor_model("ExecutorWithoutExtension")

class Rails
  def self.logger
    @@logger
  end
  def self.logger= logger
    @@logger = logger
  end
end