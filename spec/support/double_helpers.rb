def double_clazz
  double_clazz = define_clazz_class("Clazz").new
  double_clazz.stub :execute
  double_clazz
end

def double_future_task
  instance = double_clazz
  double_future_task = ActsAsExecutor::Common::FutureTask.new instance, nil
  double_future_task
end

def double_rails_logger_and_assign
  double_logger = double "Logger"
  double_logger.stub :debug
  double_logger.stub :info
  double_logger.stub :warn
  double_logger.stub :error
  double_logger.stub :fatal

  Rails.logger = double_logger
  double_logger
end