require "spec_helper"

describe ActsAsExecutor::Common::Units do
  it { ActsAsExecutor::Common::Units::NANOSECONDS.should == "nanoseconds" }
  it { ActsAsExecutor::Common::Units::MICROSECONDS.should == "microseconds" }
  it { ActsAsExecutor::Common::Units::MILLISECONDS.should == "milliseconds" }
  it { ActsAsExecutor::Common::Units::SECONDS.should == "seconds" }
  it { ActsAsExecutor::Common::Units::MINUTES.should == "minutes" }
  it { ActsAsExecutor::Common::Units::HOURS.should == "hours" }
  it { ActsAsExecutor::Common::Units::DAYS.should == "days" }
  it { ActsAsExecutor::Common::Units::ALL.should include ActsAsExecutor::Common::Units::NANOSECONDS,
                                                         ActsAsExecutor::Common::Units::MICROSECONDS,
                                                         ActsAsExecutor::Common::Units::MILLISECONDS,
                                                         ActsAsExecutor::Common::Units::SECONDS,
                                                         ActsAsExecutor::Common::Units::MINUTES,
                                                         ActsAsExecutor::Common::Units::HOURS,
                                                         ActsAsExecutor::Common::Units::DAYS
  }
end