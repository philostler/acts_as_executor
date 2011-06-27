require "spec_helper"

describe ActsAsExecutor::Executor::Model::Base do
  describe ActiveRecord::Base do
    it "should extend ActsAsExecutor::Executor::Model::Base" do
      ActiveRecord::Base.should be_kind_of(ActsAsExecutor::Executor::Model::Base)
    end
  end

  describe "#acts_as_executor" do
    context "before invocation" do
      it "should not extend ActsAsExecutor::Executor::Model::Logging" do
        ExecutorWithoutExtension.should_not be_kind_of(ActsAsExecutor::Executor::Model::Logging)
      end

      it "should not include ActsAsExecutor::Executor::Model::Actions" do
        ExecutorWithoutExtension.include?(ActsAsExecutor::Executor::Model::Actions).should be_false
      end
      it "should not include ActsAsExecutor::Executor::Model::Associations" do
        ExecutorWithoutExtension.include?(ActsAsExecutor::Executor::Model::Associations).should be_false
      end
      it "should not include ActsAsExecutor::Executor::Model::Attributes" do
        ExecutorWithoutExtension.include?(ActsAsExecutor::Executor::Model::Attributes).should be_false
      end
      it "should not include ActsAsExecutor::Executor::Model::Helpers" do
        ExecutorWithoutExtension.include?(ActsAsExecutor::Executor::Model::Helpers).should be_false
      end
      it "should not include ActsAsExecutor::Executor::Model::Validations" do
        ExecutorWithoutExtension.include?(ActsAsExecutor::Executor::Model::Validations).should be_false
      end
    end

    context "after invocation" do
      it "should extend ActsAsExecutor::Executor::Model::Logging" do
        Executor.should be_kind_of(ActsAsExecutor::Executor::Model::Logging)
      end

      it "should include ActsAsExecutor::Executor::Model::Actions" do
        Executor.include?(ActsAsExecutor::Executor::Model::Actions).should be_true
      end
      it "should include ActsAsExecutor::Executor::Model::Associations" do
        Executor.include?(ActsAsExecutor::Executor::Model::Associations).should be_true
      end
      it "should include ActsAsExecutor::Executor::Model::Attributes" do
        Executor.include?(ActsAsExecutor::Executor::Model::Attributes).should be_true
      end
      it "should include ActsAsExecutor::Executor::Model::Helpers" do
        Executor.include?(ActsAsExecutor::Executor::Model::Helpers).should be_true
      end
      it "should include ActsAsExecutor::Executor::Model::Validations" do
        Executor.include?(ActsAsExecutor::Executor::Model::Validations).should be_true
      end
    end
  end
end