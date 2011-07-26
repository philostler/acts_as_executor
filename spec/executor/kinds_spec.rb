require "spec_helper"

describe ActsAsExecutor::Executor::Kinds do
  it { ActsAsExecutor::Executor::Kinds::CACHED.should == "cached" }
  it { ActsAsExecutor::Executor::Kinds::FIXED.should == "fixed" }
  it { ActsAsExecutor::Executor::Kinds::SINGLE.should == "single" }
  it { ActsAsExecutor::Executor::Kinds::SCHEDULED.should == "scheduled" }
  it { ActsAsExecutor::Executor::Kinds::SINGLE_SCHEDULED.should == "single_scheduled" }
  it { ActsAsExecutor::Executor::Kinds::ALL.should include ActsAsExecutor::Executor::Kinds::CACHED,
                                                           ActsAsExecutor::Executor::Kinds::FIXED,
                                                           ActsAsExecutor::Executor::Kinds::SINGLE,
                                                           ActsAsExecutor::Executor::Kinds::SCHEDULED,
                                                           ActsAsExecutor::Executor::Kinds::SINGLE_SCHEDULED
  }
  it { ActsAsExecutor::Executor::Kinds::ALL_SCHEDULED.should include ActsAsExecutor::Executor::Kinds::SCHEDULED,
                                                                     ActsAsExecutor::Executor::Kinds::SINGLE_SCHEDULED
  }
  it { ActsAsExecutor::Executor::Kinds::REQUIRING_SIZE.should include ActsAsExecutor::Executor::Kinds::FIXED,
                                                                      ActsAsExecutor::Executor::Kinds::SCHEDULED
  }
end