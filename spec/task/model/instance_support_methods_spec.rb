require "spec_helper"

describe ActsAsExecutor::Task::Model::InstanceSupportMethods do
  before(:each) { @model = ExecutorTask.make }

  it { @model.should_not allow_public_access_for_methods :future, :future=, :enqueueable?, :cancelable? }

  describe "#future" do
    it "should return future" do
      future = double "Future"
      @model.send :future=, future

      @model.send(:future).should == future
    end

    context "when id has not been set" do
      it "should raise an argument error" do
        @model.id = nil

        expect { @model.send :future=, true }.to raise_error ArgumentError, "cannot reference future against nil id"
      end
    end
  end

  describe "#enqueueable?" do
    context "when future has not been set" do
      it "should return true" do
        @model.should be_enqueueable
      end
    end

    context "when future has been set" do
      it "should return false" do
        @model.send :future=, true

        @model.should_not be_enqueueable
      end
    end
  end

  describe "#cancelable?" do
    context "when future has been set" do
      it "should return true" do
        @model.send :future=, true

        @model.should be_cancelable
      end
    end

    context "when future has not been set" do
      it "should return false" do
        @model.should_not be_cancelable
      end
    end
  end
end