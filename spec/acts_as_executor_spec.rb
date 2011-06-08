require "spec_helper"

describe ActsAsExecutor do
  describe "VERSION" do
    specify { ActsAsExecutor::VERSION.should eq "1.0.0.rc1" }
  end

  describe "#rails_startup?" do
    specify { ActsAsExecutor.rails_startup?.should be_false }
  end
end