require "spec_helper"

describe ActsAsExecutor::Task::Model::ClassMethods do
  subject { ActiveRecord::Base }
  it { should be_a ActsAsExecutor::Task::Model::ClassMethods }

  describe "#acts_as_executor_task" do
    subject { ExecutorTask }
    it { should include ActsAsExecutor::Common::InstanceSupportMethods }
    it { should include ActsAsExecutor::Task::Model::InstanceMethods }
    it { should include ActsAsExecutor::Task::Model::InstanceSupportMethods }
  end
end