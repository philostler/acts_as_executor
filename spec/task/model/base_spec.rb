require "spec_helper"

describe ActsAsExecutor::Task::Model::Base do
  describe ActiveRecord::Base do
    it "should extend ActsAsExecutor::Task::Model::Base" do
      ActiveRecord::Base.should be_kind_of(ActsAsExecutor::Task::Model::Base)
    end
  end

  describe "#acts_as_executor_task" do
    context "before invocation" do
      it "should not include ActsAsExecutor::Task::Model::Actions" do
        ExecutorTaskWithoutExtension.include?(ActsAsExecutor::Task::Model::Actions).should be_false
      end
      it "should not include ActsAsExecutor::Task::Model::Associations" do
        ExecutorTaskWithoutExtension.include?(ActsAsExecutor::Task::Model::Associations).should be_false
      end
      it "should not include ActsAsExecutor::Task::Model::Attributes" do
        ExecutorTaskWithoutExtension.include?(ActsAsExecutor::Task::Model::Attributes).should be_false
      end
      it "should not include ActsAsExecutor::Task::Model::Helpers" do
        ExecutorTaskWithoutExtension.include?(ActsAsExecutor::Task::Model::Helpers).should be_false
      end
      it "should not include ActsAsExecutor::Task::Model::Validations" do
        ExecutorTaskWithoutExtension.include?(ActsAsExecutor::Task::Model::Validations).should be_false
      end
    end

    context "after invocation" do
      it "should include ActsAsExecutor::Task::Model::Actions" do
        ExecutorTask.include?(ActsAsExecutor::Task::Model::Actions).should be_true
      end
      it "should include ActsAsExecutor::Task::Model::Associations" do
        ExecutorTask.include?(ActsAsExecutor::Task::Model::Associations).should be_true
      end
      it "should include ActsAsExecutor::Task::Model::Attributes" do
        ExecutorTask.include?(ActsAsExecutor::Task::Model::Attributes).should be_true
      end
      it "should include ActsAsExecutor::Task::Model::Helpers" do
        ExecutorTask.include?(ActsAsExecutor::Task::Model::Helpers).should be_true
      end
      it "should include ActsAsExecutor::Task::Model::Validations" do
        ExecutorTask.include?(ActsAsExecutor::Task::Model::Validations).should be_true
      end
    end
  end
end