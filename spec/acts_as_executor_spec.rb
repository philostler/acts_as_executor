require "spec_helper"

describe ActsAsExecutor do
  describe "VERSION" do
    specify { ActsAsExecutor::VERSION.should eq "1.0.0.rc1" }
  end

  describe "#rails_booted?" do
    specify { ActsAsExecutor.rails_booted?.should be_false }
  end
end