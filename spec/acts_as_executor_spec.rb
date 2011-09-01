require "spec_helper"

describe ActsAsExecutor do
	it { ActsAsExecutor::VERSION.should == "1.0.0" }

  describe "#rails_initialized?" do
    context "when rails initialized" do
      it "should return true" do
        $0 = "rails"

        ActsAsExecutor.rails_initialized?.should be_true
      end
    end
    context "when rails not initialized" do
      it "should return false" do
        $0 = "rake"

        ActsAsExecutor.rails_initialized?.should be_false
      end
    end
  end
end