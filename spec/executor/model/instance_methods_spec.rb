require "spec_helper"

describe ActsAsExecutor::Executor::Model::InstanceMethods do
  before(:each) { @model = Executor.make }

  it { @model.should_not allow_public_access_for_methods :startup, :execute, :shutdown, :forced_shutdown }

  describe "#startup" do
    it "should create executor" do
      @model.send(:executor).should be_nil

      @model.send(:log).should_receive(:debug).with log_message(@model, "startup triggered")
      @model.send(:log).should_receive(:info).with log_message(@model, "started")

      @model.send :startup

      @model.send(:executor).should_not be_nil
    end
  end

  describe "#execute" do
    before(:each) { @clazz = Clazz.make }
    after(:each) { @model.send(:executor).shutdown }

    it "should execute a task" do
      @model.send :startup

      @model.send(:log).should_receive(:debug).with log_message_with_task(@model, "enqueuing", @clazz, "for execution (one time)")
      @model.send(:log).should_receive(:info).with log_message_with_task(@model, "enqueued", @clazz, "for execution (one time)")

      future = @model.send :execute, @clazz
      future.get

      future.is_done.should be_true
    end

    it "should execute a one shot task" do
      @model = Executor.make :max_tasks => 1, :schedulable => true
      @model.send :startup

      @model.send(:log).should_receive(:debug).with log_message_with_task(@model, "enqueuing", @clazz, "for execution (one shot)")
      @model.send(:log).should_receive(:info).with log_message_with_task(@model, "enqueued", @clazz, "for execution (one shot)")

      future = @model.send :execute, @clazz, ActsAsExecutor::Task::Schedules::ONE_SHOT, 0, nil, ActsAsExecutor::Common::Units::SECONDS
      future.get

      future.is_done.should be_true
    end

    it "should execute a fixed delay task" do
      @model = Executor.make :max_tasks => 1, :schedulable => true
      @model.send :startup

      @model.send(:log).should_receive(:debug).with log_message_with_task(@model, "enqueuing", @clazz, "for execution (fixed delay)")
      @model.send(:log).should_receive(:info).with log_message_with_task(@model, "enqueued", @clazz, "for execution (fixed delay)")

      future = @model.send :execute, @clazz, ActsAsExecutor::Task::Schedules::FIXED_DELAY, 0, 2, ActsAsExecutor::Common::Units::SECONDS

      future.should_not be_nil
    end

    it "should execute a fixed rate task" do
      @model = Executor.make :max_tasks => 1, :schedulable => true
      @model.send :startup

      @model.send(:log).should_receive(:debug).with log_message_with_task(@model, "enqueuing", @clazz, "for execution (fixed rate)")
      @model.send(:log).should_receive(:info).with log_message_with_task(@model, "enqueued", @clazz, "for execution (fixed rate)")

      future = @model.send :execute, @clazz, ActsAsExecutor::Task::Schedules::FIXED_RATE, 0, 2, ActsAsExecutor::Common::Units::SECONDS

      future.should_not be_nil
    end

    context "when rejected execution exception is thrown" do
      it "should log error" do
        @model.send :startup

        @model.send(:log).should_receive(:debug).with log_message_with_task(@model, "enqueuing", @clazz, "for execution (one time)")
        @model.send(:executor).should_receive(:execute).and_raise Java::java.util.concurrent.RejectedExecutionException.new
        @model.send(:log).should_receive(:warn).with log_message_with_task(@model, "enqueuing", @clazz, "encountered a rejected execution exception")

        @model.send :execute, @clazz
      end
    end

    context "when any other exception is thrown" do
      it "should log error" do
        @model = Executor.make :max_tasks => 1, :schedulable => true
        @model.send :startup

        @model.send(:log).should_receive(:debug).with log_message_with_task(@model, "enqueuing", @clazz, "for execution (one time)")
        @model.send(:log).should_receive(:error).with log_message_with_task(@model, "enqueuing", @clazz, "encountered an unexpected exception. java.lang.IllegalArgumentException: No enum const class java.util.concurrent.TimeUnit.RANDOM")

        @model.send :execute, @clazz, nil, nil, nil, "random"
      end
    end
  end

  describe "#shutdown" do
    before(:each) { @model.send :startup }

    it "should shutdown executor" do
      @model.send(:log).should_receive(:debug).with log_message(@model, "shutdown triggered")
      @model.send(:executor).should_receive :shutdown
      @model.send(:log).should_receive(:info).with log_message(@model, "shutdown")

      @model.send :shutdown

      @model.send(:executor).should be_nil
    end

    context "when security exception is thrown" do
      it "should force shutdown executor" do
        @model.send(:log).should_receive(:debug).with log_message(@model, "shutdown triggered")
        @model.send(:executor).should_receive(:shutdown).and_raise Java::java.lang.SecurityException.new
        @model.send(:log).should_receive(:warn).with log_message(@model, "shutdown encountered a security exception")
        @model.should_receive :forced_shutdown

        @model.send :shutdown
      end
    end
  end

  describe "#forced_shutdown" do
    before(:each) { @model.send :startup }

    it "should shutdown executor" do
      @model.send(:log).should_receive(:debug).with log_message(@model, "forced shutdown triggered")
      @model.send(:executor).should_receive :shutdown_now
      @model.send(:log).should_receive(:info).with log_message(@model, "forced shutdown")

      @model.send :forced_shutdown

      @model.send(:executor).should be_nil
    end

    context "when security exception is thrown" do
      it "should log error" do
        @model.send(:log).should_receive(:debug).with log_message(@model, "forced shutdown triggered")
        @model.send(:executor).should_receive(:shutdown_now).and_raise Java::java.lang.SecurityException.new
        @model.send(:log).should_receive(:error).with log_message(@model, "forced shutdown encountered a security exception")
        @model.send(:log).should_receive(:fatal).with log_message(@model, "forced shutdown failure")

        @model.send :forced_shutdown

        @model.send(:executor).should be_nil
      end
    end
  end
end