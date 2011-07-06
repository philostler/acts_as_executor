require "spec_helper"

describe ActsAsExecutor::Executor::Model::Actions do
  before :each do
    @model = Executor.new :name => example.full_description, :kind => ActsAsExecutor::Executor::Kinds::SINGLE
  end

  describe "#execute"

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
        @model.send(:log).should_receive(:debug).with("\"" + example.full_description + "\" executor startup triggered")
        @model.send(:log).should_receive(:info).with("\"" + example.full_description + "\" executor started")

        @model.save

        @model.send(:executor).should_not be_nil
      end
      it "should not create executor when an executor already exists" do
        double_rails_logger_and_assign
        should_receive_rails_booted? true

        @model.save
        executor = @model.send :executor

        @model.save

        @model.send(:executor).should == executor
      end
      it "should queue all associated tasks"
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

  describe "#shutdown" do
    it "should not be accessible publicly" do
      expect { @model.shutdown }.to raise_error NoMethodError
    end
    it "should be accessible via send method" do
      double_rails_logger_and_assign
      should_receive_rails_booted? true

      @model.save

      expect { @model.send :shutdown }.to_not raise_error NoMethodError
    end

    context "when no error is thrown during shutdown" do
      it "should shutdown executor" do
        double_rails_logger_and_assign
        should_receive_rails_booted? true

        @model.save

        @model.send(:log).should_receive(:debug).with("\"" + example.full_description + "\" executor shutdown triggered")
        @model.send(:log).should_receive(:info).with("\"" + example.full_description + "\" executor shutdown")

        @model.send :shutdown

        @model.send(:executor).should be_nil
      end
    end

    context "when security exception error is thrown during shutdown" do
      it "should force shutdown executor" do
        double_rails_logger_and_assign
        should_receive_rails_booted? true

        @model.save

        @model.send(:executor).should_not be_nil
        @model.send(:log).should_receive(:debug).with("\"" + example.full_description + "\" executor shutdown triggered")
        @model.send(:executor).should_receive(:shutdown).and_raise Java::java.lang.SecurityException.new
        @model.send(:log).should_receive(:warn).with("\"" + example.full_description + "\" executor experienced a security exception error during shutdown")
        @model.send(:log).should_receive(:debug).with("\"" + example.full_description + "\" executor shutdown (forced) triggered")
        @model.send(:executor).should_receive :shutdown_now
        @model.send(:log).should_receive(:info).with("\"" + example.full_description + "\" executor shutdown (forced)")

        @model.send :shutdown

        @model.send(:executor).should be_nil
      end
    end

    context "when security exception error is thrown during forced shutdown" do
      it "should log error and set executor nil" do
        double_rails_logger_and_assign
        should_receive_rails_booted? true

        @model.save

        @model.send(:executor).should_not be_nil
        @model.send(:log).should_receive(:debug).with("\"" + example.full_description + "\" executor shutdown triggered")
        @model.send(:executor).should_receive(:shutdown).and_raise Java::java.lang.SecurityException.new
        @model.send(:log).should_receive(:warn).with("\"" + example.full_description + "\" executor experienced a security exception error during shutdown")
        @model.send(:log).should_receive(:debug).with("\"" + example.full_description + "\" executor shutdown (forced) triggered")
        @model.send(:executor).should_receive(:shutdown_now).and_raise Java::java.lang.SecurityException.new
        @model.send(:log).should_receive(:error).with("\"" + example.full_description + "\" executor experienced a security exception error during shutdown (forced)")
        @model.send(:log).should_receive(:fatal).with("\"" + example.full_description + "\" executor shutdown (forced) failed")

        @model.send :shutdown

        @model.send(:executor).should be_nil
      end
    end
  end
end