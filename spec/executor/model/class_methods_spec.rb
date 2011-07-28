require "spec_helper"

describe ActsAsExecutor::Executor::Model::ClassMethods do
  subject { ActiveRecord::Base }
  it { should be_a ActsAsExecutor::Executor::Model::ClassMethods }

  describe "#acts_as_executor" do
    subject { Executor }
    it { should include ActsAsExecutor::Executor::Model::InstanceMethods }
    it { should include ActsAsExecutor::Executor::Model::InstanceSupportMethods }

    context "when arguments exist" do
      before :all do
        @log = Logger.new

        ExecutorWithoutActsAsExecutor.acts_as_executor :log => @log
      end

      it "should set log" do
        Rails.should_not_receive(:logger)
        ExecutorWithoutActsAsExecutor.log.should == @log
      end
    end
  end

  describe "#log" do
    after(:each) { Executor.log = Logger.new }

    it "should return log" do
      log = Logger.new
      Executor.log = log

      Rails.should_not_receive(:logger)
      Executor.log.should == log
    end

    context "when log has not been set" do
      it "should return Rails.logger" do
        log = Logger.new

        Executor.log = nil

        Rails.should_receive(:logger).at_most(:twice).and_return log
        Executor.log.should == Rails.logger
      end
    end
  end
end