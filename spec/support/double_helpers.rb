def double_clazz
  define_clazz_class("Clazz").new
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