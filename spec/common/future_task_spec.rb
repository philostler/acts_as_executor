require "spec_helper"

describe ActsAsExecutor::Common::FutureTask do
  before :each do
    @future_task = double_future_task
  end

  it "should be kind of Java::java.util.concurrent.FutureTask" do
    @future_task.should be_kind_of(Java::java.util.concurrent.FutureTask)
  end

  it "should not respond to #done_handler" do
    @future_task.should_not respond_to :done_handler
  end
  it "should respond to #done_handler=" do
    @future_task.should respond_to :done_handler=
  end

  context "#done" do
    context "done_handler exists" do
      it "should call handler" do
        double_done_handler = double "DoneHandler"
        double_done_handler.stub :done_handler

        @future_task.done_handler = double_done_handler.method :done_handler

        double_done_handler.should_receive(:done_handler)

        @future_task.done
      end
    end
    context "done_handler does not exist" do
      it "should not call handler" do
        expect { @future_task.done }.to_not raise_error
      end
    end
  end
end