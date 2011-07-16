require "spec_helper"

describe ActsAsExecutor::Executor::Model::Actions do
  before :each do
    @model = Executor.new :name => example.full_description, :kind => ActsAsExecutor::Executor::Kinds::SINGLE
  end

  after :each do
    @model.destroy
  end

  describe "#execute" do
    it "should not be accessible publicly" do
      expect { @model.execute nil, nil, nil, nil, nil }.to raise_error NoMethodError
    end
    it "should be accessible via send method" do
      double_rails_logger_and_assign
      expect { @model.send :execute, double_clazz, nil, nil, nil, nil }.to_not raise_error NoMethodError
    end

    context "when valid" do
      context "non-schedulable executor" do
        it "should successfully execute a task" do
          double_rails_logger_and_assign
          should_receive_rails_booted? true

          @model.save

          instance = double_clazz
          instance.arguments = { :attribute_one => "attribute_one", :attribute_two => "attribute_two" }
          @model.send(:log).should_receive(:debug).with "\"" + example.full_description + "\" executor enqueuing task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" for execution"
          @model.send(:log).should_receive(:debug).with "\"" + example.full_description + "\" executor enqueued task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" for execution"

          future = @model.send :execute, instance, nil, nil, nil, nil
          future.get

          future.is_done.should be_true
        end
      end
      context "schedulable executor" do
        it "should successfully execute a one shot task" do
          double_rails_logger_and_assign
          should_receive_rails_booted? true

          @model.kind = ActsAsExecutor::Executor::Kinds::SINGLE_SCHEDULED
          @model.save

          instance = double_clazz
          instance.arguments = { :attribute_one => "attribute_one", :attribute_two => "attribute_two" }
          @model.send(:log).should_receive(:debug).with "\"" + example.full_description + "\" executor enqueuing task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" for execution"
          @model.send(:log).should_receive(:debug).with "\"" + example.full_description + "\" executor enqueued task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" for execution (one shot)"

          future = @model.send :execute, instance, ActsAsExecutor::Task::Schedules::ONE_SHOT, 0, nil, ActsAsExecutor::Common::Units::SECONDS
          future.get

          future.is_done.should be_true
        end
        it "should successfully execute a fixed delay task" do
          double_rails_logger_and_assign
          should_receive_rails_booted? true

          @model.kind = ActsAsExecutor::Executor::Kinds::SINGLE_SCHEDULED
          @model.save

          instance = double_clazz
          instance.arguments = { :attribute_one => "attribute_one", :attribute_two => "attribute_two" }
          @model.send(:log).should_receive(:debug).with "\"" + example.full_description + "\" executor enqueuing task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" for execution"
          @model.send(:log).should_receive(:debug).with "\"" + example.full_description + "\" executor enqueued task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" for execution (fixed delay)"

          future = @model.send :execute, instance, ActsAsExecutor::Task::Schedules::FIXED_DELAY, 0, 2, ActsAsExecutor::Common::Units::SECONDS

          future.should_not be_nil
        end
        it "should successfully execute a fixed rate task" do
          double_rails_logger_and_assign
          should_receive_rails_booted? true

          @model.kind = ActsAsExecutor::Executor::Kinds::SINGLE_SCHEDULED
          @model.save

          instance = double_clazz
          instance.arguments = { :attribute_one => "attribute_one", :attribute_two => "attribute_two" }
          @model.send(:log).should_receive(:debug).with "\"" + example.full_description + "\" executor enqueuing task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" for execution"
          @model.send(:log).should_receive(:debug).with "\"" + example.full_description + "\" executor enqueued task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" for execution (fixed rate)"

          future = @model.send :execute, instance, ActsAsExecutor::Task::Schedules::FIXED_RATE, 0, 2, ActsAsExecutor::Common::Units::SECONDS

          future.should_not be_nil
        end
      end
    end
    context "when invalid" do
      context "when rejected execution exception error is thrown" do
        it "should log error" do
          double_rails_logger_and_assign
          should_receive_rails_booted? true

          @model.save

          instance = double_clazz
          @model.send(:log).should_receive(:debug).with "\"" + example.full_description + "\" executor enqueuing task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" for execution"
          @model.send(:executor).should_receive(:execute).and_raise Java::java.util.concurrent.RejectedExecutionException.new
          @model.send(:log).should_receive(:warn).with "\"" + example.full_description + "\" executor enqueuing task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" experienced a rejected execution exception error"

          @model.send :execute, instance, nil, nil, nil, nil
        end
      end
      context "when any exception error is thrown" do
        it "should log error" do
          double_rails_logger_and_assign
          should_receive_rails_booted? true

          @model.kind = ActsAsExecutor::Executor::Kinds::SINGLE_SCHEDULED
          @model.save

          instance = double_clazz
          @model.send(:log).should_receive(:debug).with "\"" + example.full_description + "\" executor enqueuing task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" for execution"
          @model.send(:log).should_receive(:error).with "\"" + example.full_description + "\" executor enqueuing task \"" + instance.class.name + "\" with arguments \"" + instance.arguments.inspect + "\" experienced an exception error. java.lang.IllegalArgumentException: No enum const class java.util.concurrent.TimeUnit.RANDOM"

          @model.send :execute, instance, nil, nil, nil, "random"
        end
      end
    end
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
        @model.send(:log).should_receive(:debug).with "\"" + example.full_description + "\" executor startup triggered"
        @model.send(:log).should_receive(:info).with "\"" + example.full_description + "\" executor started"

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

    context "when no error is thrown" do
      it "should shutdown executor" do
        double_rails_logger_and_assign
        should_receive_rails_booted? true

        @model.save

        @model.send(:log).should_receive(:debug).with "\"" + example.full_description + "\" executor shutdown triggered"
        @model.send(:executor).should_receive :shutdown
        @model.send(:log).should_receive(:info).with "\"" + example.full_description + "\" executor shutdown"

        @model.send :shutdown

        @model.send(:executor).should be_nil
      end
    end

    context "when security exception error is thrown" do
      it "should force shutdown executor" do
        double_rails_logger_and_assign
        should_receive_rails_booted? true

        @model.save

        @model.send(:log).should_receive(:debug).with "\"" + example.full_description + "\" executor shutdown triggered"
        @model.send(:executor).should_receive(:shutdown).and_raise Java::java.lang.SecurityException.new
        @model.send(:log).should_receive(:warn).with "\"" + example.full_description + "\" executor experienced a security exception error during shutdown"
        @model.should_receive :shutdown_forced

        @model.send :shutdown

        @model.send(:executor).should be_nil
      end
    end
  end

  describe "#shutdown_forced" do
    it "should not be accessible publicly" do
      expect { @model.shutdown_forced }.to raise_error NoMethodError
    end
    it "should be accessible via send method" do
      double_rails_logger_and_assign
      should_receive_rails_booted? true

      @model.save

      expect { @model.send :shutdown_forced }.to_not raise_error NoMethodError
    end

    context "when no error is thrown" do
      it "should force shutdown executor" do
        double_rails_logger_and_assign
        should_receive_rails_booted? true

        @model.save

        @model.send(:log).should_receive(:debug).with "\"" + example.full_description + "\" executor shutdown (forced) triggered"
        @model.send(:executor).should_receive :shutdown_now
        @model.send(:log).should_receive(:info).with "\"" + example.full_description + "\" executor shutdown (forced)"

        @model.send :shutdown_forced

        @model.send(:executor).should be_nil
      end
    end

    context "when security exception error is thrown" do
      it "should log error" do
        double_rails_logger_and_assign
        should_receive_rails_booted? true

        @model.save

        @model.send(:log).should_receive(:debug).with "\"" + example.full_description + "\" executor shutdown (forced) triggered"
        @model.send(:executor).should_receive(:shutdown_now).and_raise Java::java.lang.SecurityException.new
        @model.send(:log).should_receive(:error).with "\"" + example.full_description + "\" executor experienced a security exception error during shutdown (forced)"
        @model.send(:log).should_receive(:fatal).with "\"" + example.full_description + "\" executor shutdown (forced) failed"

        @model.send :shutdown_forced

        @model.send(:executor).should be_nil
      end
    end
  end
end