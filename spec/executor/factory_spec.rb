require "spec_helper"

describe ActsAsExecutor::Executor::Factory do
  describe "#create" do
    context "when valid" do
      context "when specifying cached kind" do
        it "should return a ExecutorService" do
          ActsAsExecutor::Executor::Factory.create(ActsAsExecutor::Executor::Kinds::CACHED).should be_a Java::java.util.concurrent.ExecutorService
        end
      end

      context "when specifying fixed kind" do
        context "when valid" do
          it "should return a ExecutorService of size 1" do
            e = ActsAsExecutor::Executor::Factory.create(ActsAsExecutor::Executor::Kinds::FIXED, 1)
            e.should be_a Java::java.util.concurrent.ExecutorService
            e.core_pool_size.should eq 1
          end
          it "should return a ExecutorService of size 50" do
            e = ActsAsExecutor::Executor::Factory.create(ActsAsExecutor::Executor::Kinds::FIXED, 50)
            e.should be_a Java::java.util.concurrent.ExecutorService
            e.core_pool_size.should eq 50
          end
          it "should return a ExecutorService of size 999999" do
            e = ActsAsExecutor::Executor::Factory.create(ActsAsExecutor::Executor::Kinds::FIXED, 999999)
            e.should be_a Java::java.util.concurrent.ExecutorService
            e.core_pool_size.should eq 999999
          end
        end
        context "when invalid" do
          it "should throw TypeError for size nil" do
            expect { ActsAsExecutor::Executor::Factory.create(ActsAsExecutor::Executor::Kinds::FIXED) }.to raise_error TypeError
          end
          it "should throw ArgumentError for size 0" do
            expect { ActsAsExecutor::Executor::Factory.create(ActsAsExecutor::Executor::Kinds::FIXED, 0) }.to raise_error ArgumentError
          end
        end
      end

      context "when specifying single kind" do
        it "should return a ExecutorService" do
          ActsAsExecutor::Executor::Factory.create(ActsAsExecutor::Executor::Kinds::SINGLE).should be_a Java::java.util.concurrent.ExecutorService
        end
      end

      context "when specifying scheduled kind" do
        context "when valid" do
          it "should return a ScheduledExecutorService of size 1" do
            e = ActsAsExecutor::Executor::Factory.create(ActsAsExecutor::Executor::Kinds::SCHEDULED, 1)
            e.should be_a Java::java.util.concurrent.ScheduledExecutorService
            e.core_pool_size.should eq 1
          end
          it "should return a ScheduledExecutorService of size 50" do
            e = ActsAsExecutor::Executor::Factory.create(ActsAsExecutor::Executor::Kinds::SCHEDULED, 50)
            e.should be_a Java::java.util.concurrent.ScheduledExecutorService
            e.core_pool_size.should eq 50
          end
          it "should return a ScheduledExecutorService of size 999999" do
            e = ActsAsExecutor::Executor::Factory.create(ActsAsExecutor::Executor::Kinds::SCHEDULED, 999999)
            e.should be_a Java::java.util.concurrent.ScheduledExecutorService
            e.core_pool_size.should eq 999999
          end
        end
        context "when invalid" do
          it "should throw TypeError for size nil" do
            expect { ActsAsExecutor::Executor::Factory.create(ActsAsExecutor::Executor::Kinds::SCHEDULED) }.to raise_error TypeError
          end
          it "should throw ArgumentError for size 0" do
            expect { ActsAsExecutor::Executor::Factory.create(ActsAsExecutor::Executor::Kinds::SCHEDULED, 0) }.to raise_error ArgumentError
          end
        end
      end

      context "when specifying single_scheduled kind" do
        it "should return a ScheduledExecutorService" do
          ActsAsExecutor::Executor::Factory.create(ActsAsExecutor::Executor::Kinds::SINGLE_SCHEDULED).should be_a Java::java.util.concurrent.ScheduledExecutorService
        end
      end
    end
    context "when invalid" do
      it "should return nil for nil kind" do
        ActsAsExecutor::Executor::Factory.create(nil).should be_nil
      end
    end
  end
end