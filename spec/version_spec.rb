require "spec_helper"

describe "version" do
  specify { ActsAsExecutor::VERSION.should eq "1.0.0.rc1" }
end