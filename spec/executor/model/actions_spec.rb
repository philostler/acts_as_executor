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
      expect { @model.send :startup }.to_not raise_error NoMethodError
    end

    context "when valid" do
      it "should create executor" do
        double_rails_logger_and_assign
        should_receive_rails_booted? true

        @model.send(:executor).should be_nil
        @model.send(:log).should_receive(:debug).with("\"Executor\" executor startup triggered")
        @model.send(:log).should_receive(:info).with("\"Executor\" executor started")

        @model.save

        @model.send(:executor).should_not be_nil
      end
      it "should not create executor when an executor already exists" do
        should_receive_rails_booted? true

        @model.save
        executor = @model.send :executor

        @model.save

        @model.send(:executor).should == executor
      end
      it "should queue all association tasks"
    end
    context "when invalid" do
      it "should not create executor" do
        should_receive_rails_booted? true
        @model.name = ""
        @model.kind = ""

        @model.save

        @model.send(:executor).should be_nil
      end
    end
  end
end