require "spec_helper"

describe ActsAsExecutor::Task::Schedules do
  describe "ONE_SHOT" do
    specify { ActsAsExecutor::Task::Schedules::ONE_SHOT.should == "one_shot" }
  end
  describe "FIXED_DELAY" do
    specify { ActsAsExecutor::Task::Schedules::FIXED_DELAY.should == "fixed_delay" }
  end
  describe "FIXED_RATE" do
    specify { ActsAsExecutor::Task::Schedules::FIXED_RATE.should == "fixed_rate" }
  end

  describe "ALL" do
    specify { ActsAsExecutor::Task::Schedules::ALL.should include(
      ActsAsExecutor::Task::Schedules::ONE_SHOT,
      ActsAsExecutor::Task::Schedules::FIXED_DELAY,
      ActsAsExecutor::Task::Schedules::FIXED_RATE) }
  end
end