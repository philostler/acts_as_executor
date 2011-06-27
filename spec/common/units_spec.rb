require "spec_helper"

describe ActsAsExecutor::Common::Units do
  describe "NANOSECONDS" do
    specify { ActsAsExecutor::Common::Units::NANOSECONDS.should == "nanoseconds" }
  end
  describe "MICROSECONDS" do
    specify { ActsAsExecutor::Common::Units::MICROSECONDS.should == "microseconds" }
  end
  describe "MILLISECONDS" do
    specify { ActsAsExecutor::Common::Units::MILLISECONDS.should == "milliseconds" }
  end
  describe "SECONDS" do
    specify { ActsAsExecutor::Common::Units::SECONDS.should == "seconds" }
  end
  describe "MINUTES" do
    specify { ActsAsExecutor::Common::Units::MINUTES.should == "minutes" }
  end
  describe "HOURS" do
    specify { ActsAsExecutor::Common::Units::HOURS.should == "hours" }
  end
  describe "DAYS" do
    specify { ActsAsExecutor::Common::Units::DAYS.should == "days" }
  end

  describe "ALL" do
    specify { ActsAsExecutor::Common::Units::ALL.should include(
      ActsAsExecutor::Common::Units::NANOSECONDS,
      ActsAsExecutor::Common::Units::MICROSECONDS,
      ActsAsExecutor::Common::Units::MILLISECONDS,
      ActsAsExecutor::Common::Units::SECONDS,
      ActsAsExecutor::Common::Units::MINUTES,
      ActsAsExecutor::Common::Units::HOURS,
      ActsAsExecutor::Common::Units::DAYS) }
  end
end