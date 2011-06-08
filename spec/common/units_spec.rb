require "spec_helper"

describe ActsAsExecutor::Common::Units do
  describe "NANOSECONDS" do
    specify { ActsAsExecutor::Common::Units::NANOSECONDS.should eq "nanoseconds" }
  end
  describe "MICROSECONDS" do
    specify { ActsAsExecutor::Common::Units::MICROSECONDS.should eq "microseconds" }
  end
  describe "MILLISECONDS" do
    specify { ActsAsExecutor::Common::Units::MILLISECONDS.should eq "milliseconds" }
  end
  describe "SECONDS" do
    specify { ActsAsExecutor::Common::Units::SECONDS.should eq "seconds" }
  end
  describe "MINUTES" do
    specify { ActsAsExecutor::Common::Units::MINUTES.should eq "minutes" }
  end
  describe "HOURS" do
    specify { ActsAsExecutor::Common::Units::HOURS.should eq "hours" }
  end
  describe "DAYS" do
    specify { ActsAsExecutor::Common::Units::DAYS.should eq "days" }
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