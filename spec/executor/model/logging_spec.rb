require "spec_helper"

describe ActsAsExecutor::Executor::Model::Logging do
  describe "#logger" do
    context "default logger" do
      it "should return Rails.logger" do
        double_logger = double "Logger"
        Rails.logger = double_logger

        @model = Executor.new
        @model.log.should eq double_logger
        @model.logger.should eq double_logger
      end
    end
    context "custom logger" do
      it "should return custom logger" do
        double_logger = double "Logger"

        ExecutorWithoutExtension.acts_as_executor :logger => double_logger

        @model = ExecutorWithoutExtension.new
        @model.log.should eq double_logger
        @model.logger.should eq double_logger
      end
    end
    context "nil logger" do
      it "should return Rails.logger" do
        double_logger = double "Logger"
        Rails.logger = double_logger

        ExecutorWithoutExtension.acts_as_executor :logger => nil

        @model = ExecutorWithoutExtension.new
        @model.log.should eq double_logger
        @model.logger.should eq double_logger
      end
    end
  end
end