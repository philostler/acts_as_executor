require "spec_helper"

describe ActsAsExecutor::Executor::Kinds do
  describe "CACHED" do
    specify { ActsAsExecutor::Executor::Kinds::CACHED.should eq "cached" }
  end
  describe "FIXED" do
    specify { ActsAsExecutor::Executor::Kinds::FIXED.should eq "fixed" }
  end
  describe "SINGLE" do
    specify { ActsAsExecutor::Executor::Kinds::SINGLE.should eq "single" }
  end
  describe "SCHEDULED" do
    specify { ActsAsExecutor::Executor::Kinds::SCHEDULED.should eq "scheduled" }
  end
  describe "SINGLE_SCHEDULED" do
    specify { ActsAsExecutor::Executor::Kinds::SINGLE_SCHEDULED.should eq "single_scheduled" }
  end

  describe "ALL" do
    specify { ActsAsExecutor::Executor::Kinds::ALL.should include(
      ActsAsExecutor::Executor::Kinds::CACHED,
      ActsAsExecutor::Executor::Kinds::FIXED,
      ActsAsExecutor::Executor::Kinds::SINGLE,
      ActsAsExecutor::Executor::Kinds::SCHEDULED,
      ActsAsExecutor::Executor::Kinds::SINGLE_SCHEDULED) }
  end
  describe "ALL_SCHEDULED" do
    specify { ActsAsExecutor::Executor::Kinds::ALL_SCHEDULED.should include(
      ActsAsExecutor::Executor::Kinds::SCHEDULED,
      ActsAsExecutor::Executor::Kinds::SINGLE_SCHEDULED) }
  end
  describe "REQUIRING_SIZE" do
    specify { ActsAsExecutor::Executor::Kinds::REQUIRING_SIZE.should include(
      ActsAsExecutor::Executor::Kinds::FIXED,
      ActsAsExecutor::Executor::Kinds::SCHEDULED) }
  end
end
