require "spec_helper"

describe ActsAsExecutor::Executor::Model::Actions do
  before :each do
    @model = Executor.new :name => "Executor", :kind => ActsAsExecutor::Executor::Kinds::SINGLE
  end

  describe "#startup" do
    it "should not be accessible publicly" do
      expect { @model.startup }.to raise_error NoMethodError
    end
    it "should be accessible via send method" do
      double_rails_logger_and_assign
      expect { @model.send :startup }.to_not raise_error
    end

    context "when valid" do
      it "should create executor" do
        double_rails_logger_and_assign
        should_receive_rails_booted? true
        @model.id = 1

        @model.send(:executor).should be_nil
        @model.send(:log).should_receive(:debug).with("\"Executor\" executor startup triggered")
        @model.send(:log).should_receive(:info).with("\"Executor\" executor started")

        @model.send :startup

        @model.send(:executor).should_not be_nil
      end
      it "should not create executor when already invoked and not shutdown" do
        double_rails_logger_and_assign
        should_receive_rails_booted? true
        @model.id = 2

        @model.send :startup
        executor = @model.send :executor

        @model.send(:log).should_receive(:warn).with("\"Executor\" executor startup triggered but has already been started")

        @model.send :startup

        @model.send(:executor).should == executor
      end
      it "should queue all association tasks" do
      end
    end
    context "when invalid" do
      it "should not create executor" do
      end
    end
  end
end