require "spec_helper"

describe ActsAsExecutor::Task::Clazz do
  before(:each) { @model = Clazz.make }

  it { @model.should be_a Java::java.lang.Runnable }
  it { @model.should_not allow_public_access_for_methods :run }

  describe "#run" do
    it "should invoke execute" do
      @model.should_receive :execute

      @model.send :run
    end
    it "should create accessor for each arguments member" do
      @model.send :run

      @model.arguments.each_pair do |key, value|
        @model.should respond_to key
        @model.send(key).should == value
      end
    end

    context "when any exception is thrown" do
      context "when uncaught exception handler exists" do
        it "should invoke handler" do
          handler = double "Handler"
          handler.stub :uncaught_exception_handler
          @model.uncaught_exception_handler = handler.method :uncaught_exception_handler

          error = RuntimeError.new

          @model.should_receive(:execute).and_raise error

          handler.should_receive(:uncaught_exception_handler).with error

          @model.send :run
        end
      end
    end
  end
end