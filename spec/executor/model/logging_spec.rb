require "spec_helper"

describe ActsAsExecutor::Executor::Model::Logging do
  describe "#logger" do
    context "default logger" do
      it "should return Rails.logger" do
        double_logger = double_rails_logger

        @model = Executor.new
        @model.log.should eq double_logger
        @model.logger.should eq double_logger
      end
    end
    context "custom logger" do
      it "should return custom logger" do
        double_logger = double "Logger"

        double_executor_model "ExecutorWithCustomLogger"
        ExecutorWithCustomLogger.acts_as_executor :logger => double_logger

        @model = ExecutorWithCustomLogger.new
        @model.log.should eq double_logger
        @model.logger.should eq double_logger
      end
    end
    context "nil logger" do
      it "should return Rails.logger" do
        double_logger = double_rails_logger

        double_executor_model "ExecutorWithNilLogger"
        ExecutorWithNilLogger.acts_as_executor :logger => nil

        @model = ExecutorWithNilLogger.new
        @model.log.should eq double_logger
        @model.logger.should eq double_logger
      end
    end
  end
end