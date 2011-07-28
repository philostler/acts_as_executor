require "spec_helper"

describe ActsAsExecutor::Executor::Factory do
  describe "#create" do
    it "should invoke matching create method for kind" do
      ActsAsExecutor::Executor::Factory.should_receive :create_cached

      ActsAsExecutor::Executor::Factory.create ActsAsExecutor::Executor::Kinds::CACHED
    end

    context "when no kind is given" do
      it "should return nil" do
        ActsAsExecutor::Executor::Factory.create(nil).should be_nil
      end
    end
  end

  describe "#create_cached" do
    it "should return an executor" do
      ActsAsExecutor::Executor::Factory.create_cached.should be_a Java::java.util.concurrent.ExecutorService
    end
  end

  describe "#create_fixed" do
    it "should return an executor" do
      executor = ActsAsExecutor::Executor::Factory.create_fixed 5

      executor.should be_a Java::java.util.concurrent.ExecutorService
      executor.core_pool_size.should == 5
    end

    context "when no size is given" do
      it "should raise a type error" do
        expect { ActsAsExecutor::Executor::Factory.create_fixed nil }.to raise_error TypeError, "size cannot be nil"
      end
    end

    context "when given size is less than or equal to zero" do
      it "should raise an argument error" do
        expect { ActsAsExecutor::Executor::Factory.create_fixed 0 }.to raise_error ArgumentError, "size must be larger than 0"
      end
    end
  end

  describe "#create_single" do
    it "should return an executor" do
      ActsAsExecutor::Executor::Factory.create_single.should be_a Java::java.util.concurrent.ExecutorService
    end
  end

  describe "#create_scheduled" do
    it "should return an executor" do
      executor = ActsAsExecutor::Executor::Factory.create_scheduled 5

      executor.should be_a Java::java.util.concurrent.ScheduledExecutorService
      executor.core_pool_size.should == 5
    end

    context "when no size is given" do
      it "should raise a type error" do
        expect { ActsAsExecutor::Executor::Factory.create_scheduled nil }.to raise_error TypeError, "size cannot be nil"
      end
    end

    context "when given size is less than or equal to zero" do
      it "should raise an argument error" do
        expect { ActsAsExecutor::Executor::Factory.create_scheduled 0 }.to raise_error ArgumentError, "size must be larger than 0"
      end
    end
  end

  describe "#create_single_scheduled" do
    it "should return an executor" do
      ActsAsExecutor::Executor::Factory.create_single_scheduled.should be_a Java::java.util.concurrent.ScheduledExecutorService
    end
  end
end