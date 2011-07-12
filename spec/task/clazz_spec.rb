require "spec_helper"

describe ActsAsExecutor::Task::Clazz do
  before :each do
    @clazz = double_clazz
  end

  describe "when included" do
    it "should be kind of Java::java.lang.Runnable" do
      @clazz.should be_kind_of(Java::java.lang.Runnable)
    end

    it "should not respond to #run public" do
      @clazz.should_not respond_to :run
    end
    it "should respond to #run private" do
      @clazz.respond_to?(:run, true).should be_true
    end

    it "should not respond to #arguments" do
      @clazz.should_not respond_to :arguments
    end
    it "should respond to #arguments=" do
      @clazz.should respond_to :arguments=
    end

    context "#run" do
      it "should respond to each argument as a getter" do
        @clazz.should_receive :execute

        @clazz.arguments = { :attribute_one => "attribute_one", :attribute_two => "attribute_two" }
        @clazz.send :run

        @clazz.should respond_to :attribute_one
        @clazz.attribute_one.should == "attribute_one"
        @clazz.should respond_to :attribute_two
        @clazz.attribute_two.should == "attribute_two"
      end
      it "should respond to each argument as a setter" do
        @clazz.should_receive :execute

        @clazz.arguments = { :attribute_one => "attribute_one", :attribute_two => "attribute_two" }
        @clazz.send :run

        @clazz.should respond_to :attribute_one=
        @clazz.should respond_to :attribute_two=
      end
      it "should respond to new arguments between invokes" do
        @clazz.should_receive(:execute).twice

        @clazz.arguments = { :attribute_one => "attribute_one", :attribute_two => "attribute_two" }
        @clazz.send :run

        @clazz.should respond_to :attribute_one
        @clazz.attribute_one.should == "attribute_one"
        @clazz.should respond_to :attribute_two
        @clazz.attribute_two.should == "attribute_two"
        @clazz.should_not respond_to :attribute_three
        @clazz.should_not respond_to :attribute_fout

        @clazz.arguments = { :attribute_three => "attribute_three", :attribute_four => "attribute_four" }
        @clazz.send :run
        @clazz.should respond_to :attribute_one
        @clazz.attribute_one.should == "attribute_one"
        @clazz.should respond_to :attribute_two
        @clazz.attribute_two.should == "attribute_two"
        @clazz.should respond_to :attribute_three
        @clazz.attribute_three.should == "attribute_three"
        @clazz.should respond_to :attribute_four
        @clazz.attribute_four.should == "attribute_four"
      end
      it "should catch uncaught exceptions and invoke uncaught exception handler" do
        double_uncaught_exception_handler = double "UncaughtExceptionHandler"
        double_uncaught_exception_handler.stub :uncaught_exception_handler

        @clazz.uncaught_exception_handler = double_uncaught_exception_handler.method :uncaught_exception_handler

        exception = Exception.new
        @clazz.should_receive(:execute).and_raise exception
        double_uncaught_exception_handler.should_receive(:uncaught_exception_handler).with(exception)

        @clazz.send :run
      end
    end
  end
end