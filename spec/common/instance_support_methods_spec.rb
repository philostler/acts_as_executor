require "spec_helper"

describe ActsAsExecutor::Common::InstanceSupportMethods do
  before(:each) { @model = InstanceSupportMethods.make }

  it { @model.should_not allow_public_access_for_methods :log_statement, :log_message }

  describe "#log_statement" do
    it "should return a string" do
      @model.send(:log_statement, "name", "statement").should == log_statement("name", "statement")
    end
  end

  describe "#log_message" do
    it "should return a string" do
      @model.send(:log_message, "name", "doing", 1.to_s, "executable", "message").should == log_message("name", "doing", 1.to_s, "executable", "message")
    end

    context "when message is a hash" do
      it "should return a string" do
        @model.send(:log_message, "name", "doing", 1.to_s, "executable", {:attribute_one => "attribute_one_value", :attribute_two => "attribute_two_value"}).should == log_message("name", "doing", 1.to_s, "executable", {:attribute_one => "attribute_one_value", :attribute_two => "attribute_two_value"})
      end
    end
  end
end