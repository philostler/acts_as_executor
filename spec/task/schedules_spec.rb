require "spec_helper"

describe ActsAsExecutor::Task::Schedules do
  it { ActsAsExecutor::Task::Schedules::ONE_SHOT.should == "one_shot" }
  it { ActsAsExecutor::Task::Schedules::FIXED_DELAY.should == "fixed_delay" }
  it { ActsAsExecutor::Task::Schedules::FIXED_RATE.should == "fixed_rate" }
  it { ActsAsExecutor::Task::Schedules::ALL.should include ActsAsExecutor::Task::Schedules::ONE_SHOT,
                                                           ActsAsExecutor::Task::Schedules::FIXED_DELAY,
                                                           ActsAsExecutor::Task::Schedules::FIXED_RATE
  }
end