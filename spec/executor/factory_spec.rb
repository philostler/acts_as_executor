require "spec_helper"

describe ActsAsExecutor::Executor::Factory do
  describe "#create" do
    it "should return a scheduled executor" do
      executor = ActsAsExecutor::Executor::Factory.create 5, true

      executor.should be_a Java::java.util.concurrent.ScheduledExecutorService
      executor.core_pool_size.should == 5
    end

    it "should return a single scheduled executor" do
      ActsAsExecutor::Executor::Factory.create(1, true).should be_a Java::java.util.concurrent.ScheduledExecutorService
    end

    it "should return a cached executor" do
      ActsAsExecutor::Executor::Factory.create(nil, nil).should be_a Java::java.util.concurrent.ExecutorService
    end

    it "should return a fixed executor" do
      executor = ActsAsExecutor::Executor::Factory.create 5, nil

      executor.should be_a Java::java.util.concurrent.ExecutorService
      executor.core_pool_size.should == 5
    end

    it "should return a single executor" do
      ActsAsExecutor::Executor::Factory.create(1, nil).should be_a Java::java.util.concurrent.ExecutorService
    end
  end
end