require "spec_helper"

describe ActsAsExecutor::Executor::Model::InstanceSupportMethods do
  before(:each) { @model = Executor.make }

  it { @model.should_not allow_public_access_for_methods :executor, :executor=, :startupable?, :shutdownable?, :log }

  describe "#executor" do
    it "should return executor" do
      executor = double "Executor"
      @model.send :executor=, executor

      @model.send(:executor).should == executor
    end

    context "when id has not been set" do
      it "should raise an argument error" do
        @model.id = nil

        expect { @model.send :executor=, true }.to raise_error ArgumentError, "cannot reference executor against nil id"
      end
    end
  end

  describe "#startupable?" do
    context "when rails initialized" do
      before(:each) { ActsAsExecutor.should_receive(:rails_initialized?).at_most(:once).and_return true }

      context "when executor has not been set" do
        it "should return true" do
          @model.should be_startupable
        end
      end

      context "when executor has been set" do
        it "should return false" do
          @model.send :startup

          @model.should_not be_startupable
        end
      end
    end
  end

  describe "#shutdownable?" do
    context "when rails initialized" do
      before(:each) { ActsAsExecutor.should_receive(:rails_initialized?).at_most(:once).and_return true }

      context "when executor has been set" do
        it "should return true" do
          @model.send :startup

          @model.should be_shutdownable
        end
      end

      context "when executor has not been set" do
        it "should return false" do
          @model.should_not be_shutdownable
        end
      end
    end
  end

  describe "#log" do
    it "should return class log" do
      @model.send(:log).should == Executor.log
    end
  end
end