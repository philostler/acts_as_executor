require "spec_helper"

describe ActsAsExecutor::Executor::Model::Logging do
  describe "#logger" do
    context "default logger" do
      it "should return Rails.logger" do
        double_logger = double_rails_logger_and_assign

        @model = Executor.new
        @model.send(:log).should == double_logger
        @model.send(:logger).should == double_logger
      end
    end
    context "custom logger" do
      it "should return custom logger" do
        double_logger = double "Logger"

        define_executor_model_class "ExecutorWithCustomLogger"
        ExecutorWithCustomLogger.acts_as_executor :logger => double_logger

        @model = ExecutorWithCustomLogger.new
        @model.send(:log).should == double_logger
        @model.send(:logger).should == double_logger
      end
    end
    context "nil logger" do
      it "should return Rails.logger" do
        double_logger = double_rails_logger_and_assign

        define_executor_model_class "ExecutorWithNilLogger"
        ExecutorWithNilLogger.acts_as_executor :logger => nil

        @model = ExecutorWithNilLogger.new
        @model.send(:log).should == double_logger
        @model.send(:logger).should == double_logger
      end
    end
  end
end