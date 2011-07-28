require "spec_helper"

describe ActsAsExecutor::Executor::Model::InstanceSupportMethods do
  before(:each) { @model = Executor.make }

  it { @model.should allow_public_access_for_methods :schedulable? }
  it { @model.should_not allow_public_access_for_methods :can_startup?, :can_shutdown?, :executor, :executor=, :log, :log_message, :log_message_with_task }

  describe "#schedulable?" do
    it "should return true when schedulable" do
      @model.kind = ActsAsExecutor::Executor::Kinds::SINGLE_SCHEDULED

      @model.should be_schedulable
    end

    it "should return false when not schedulable" do
      @model.should_not be_schedulable
    end
  end

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

  describe "#startup_able?" do
    context "when rails initialized" do
      before(:each) { ActsAsExecutor.should_receive(:rails_initialized?).at_most(:once).and_return true }

      context "when executor has not been set" do
        it "should return true" do
          @model.should be_startup_able
        end
      end

      context "when executor has been set" do
        it "should return false" do
          @model.send :startup

          @model.should_not be_startup_able
        end
      end
    end
  end

  describe "#shutdown_able?" do
    context "when rails initialized" do
      before(:each) { ActsAsExecutor.should_receive(:rails_initialized?).at_most(:once).and_return true }

      context "when executor has been set" do
        it "should return true" do
          @model.send :startup

          @model.should be_shutdown_able
        end
      end

      context "when executor has not been set" do
        it "should return false" do
          @model.should_not be_shutdown_able
        end
      end
    end
  end

  describe "#log" do
    it "should return class log" do
      @model.send(:log).should == Executor.log
    end
  end

  describe "#log_message" do
    it "should return log message" do
      @model.send(:log_message, "message").should == log_message(@model, "message")
    end
  end

  describe "#log_message_with_task" do
    it "should return log message" do
      clazz = Clazz.make

      @model.send(:log_message_with_task, "doing", clazz, "message").should == log_message_with_task(@model, "doing", clazz, "message")
    end
  end
end