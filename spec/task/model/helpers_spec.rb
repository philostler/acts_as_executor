require "spec_helper"

describe ActsAsExecutor::Task::Model::Helpers do
  before :each do
    @model = ExecutorTask.new
  end

  describe "#can_execute?" do
    context "when future exists" do
      it "should return false" do
        @model.id = 1
        @model.send :future=, true

        @model.can_execute?.should be_false
      end
    end
    context "when future does not exist" do
      it "should return true" do
        @model.id = 1
        @model.send :future=, nil

        @model.can_execute?.should be_true
      end
    end
  end

  describe "#can_cancel?" do
    context "when future exists" do
      it "should return true" do
        @model.id = 1
        @model.send :future=, true

        @model.can_cancel?.should be_true
      end
    end
    context "when future does not exist" do
      it "should return false" do
        @model.id = 1
        @model.send :future=, nil

        @model.can_cancel?.should be_false
      end
    end
  end
end