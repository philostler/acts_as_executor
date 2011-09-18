require "spec_helper"

describe ActsAsExecutor::Task::Model::InstanceMethods do
  before(:each) { @model = ExecutorTask.make }

  it { @model.should_not allow_public_access_for_methods :enqueue, :instantiate, :cancel, :done_handler, :uncaught_exception_handler }

  describe "#enqueue" do
    before(:each) { @clazz = Clazz.make }

    it "should enqueue task" do
      @model.send(:future).should be_nil

      future = double "Future"
      future.stub :done_handler=

      @model.executor.send(:log).should_receive(:debug).with log_message(@model.executor.name, "creating", @model.id.to_s, @model.clazz, @model.arguments)
      @model.should_receive(:instantiate).and_return @clazz
      @model.executor.should_receive(:execute).with(@clazz, @model.id.to_s, @model.schedule, @model.start, @model.every, @model.units).and_return future

      @model.send :enqueue

      @model.send(:future).should == future
    end

    context "when any exception is thrown" do
      it "should log exception" do
        exception = RuntimeError.new

        @model.should_receive(:instantiate).and_raise exception
        @model.executor.send(:log).should_receive(:error).with log_message(@model.executor.name, "creating", @model.id.to_s, @model.clazz, "encountered an unexpected exception. " + exception.to_s)

        @model.send :enqueue
      end
    end
  end

  describe "#instantiate" do
    it "should return an instance" do
      instance = @model.send :instantiate, @model.clazz, @model.arguments

      instance.class.name.should == @model.clazz
      instance.arguments.should == @model.arguments
    end
  end

  describe "#done_handler" do
    it "should invoke destroy" do
      @model.executor.send(:log).should_receive(:debug).with log_message(@model.executor.name, "completed", @model.id.to_s, @model.clazz)
      @model.should_receive :destroy

      @model.send :done_handler
    end
  end

  describe "#uncaught_exception_handler" do
    before(:each) { @clazz = Clazz.make }

    it "should log exception" do
      exception = RuntimeError.new

      @model.executor.send(:log).should_receive(:error).with log_message(@model.executor.name, "executing", @model.id.to_s, @model.clazz, "encountered an uncaught exception. " + exception.to_s)

      @model.send :uncaught_exception_handler, exception
    end
  end

  describe "#cancel" do
    it "should cancel task" do
      future = double "Future"
      @model.send :future=, future

      @model.send(:future).should_receive(:cancel).with true

      @model.send :cancel

      @model.send(:future).should be_nil
    end
  end
end