require "spec_helper"

describe ActsAsExecutor::Executor::Model::Helpers do
  before :each do
    @model = Executor.new
  end

  describe "#can_startup?" do
    context "when valid" do
      it "should return true" do
        @model.id = 1
        @model.send :executor=, nil
        should_receive_rails_booted? true

        @model.can_startup?.should be_true
      end
    end
    context "when invalid" do
      it "should return false when executor is not nil" do
        @model.id = 1
        @model.send :executor=, true
        should_receive_rails_booted? true

        @model.can_startup?.should be_false
      end
      it "should return false when rails_booted? is false" do
        @model.id = 1
        @model.send :executor=, nil
        should_receive_rails_booted? false

        @model.can_startup?.should be_false
      end
    end
  end

  describe "#can_shutdown?" do
    context "when valid" do
      it "should return true" do
        @model.id = 1
        @model.send :executor=, true
        should_receive_rails_booted? true

        @model.can_shutdown?.should be_true
      end
    end
    context "when invalid" do
      it "should return false when executor is nil" do
        @model.id = 1
        @model.send :executor=, nil
        should_receive_rails_booted? true

        @model.can_shutdown?.should be_false
      end
      it "should return false when rails_booted? is false" do
        @model.id = 1
        @model.send :executor=, true
        should_receive_rails_booted? false

        @model.can_shutdown?.should be_false
      end
    end
  end

  describe "#schedulable?" do
    context "when valid" do
      it "should return false when kind is cached" do
        @model.kind = ActsAsExecutor::Executor::Kinds::CACHED
        @model.schedulable?.should be_false
      end
      it "should return false when kind is fixed" do
        @model.kind = ActsAsExecutor::Executor::Kinds::FIXED
        @model.schedulable?.should be_false
      end
      it "should return false when kind is single" do
        @model.kind = ActsAsExecutor::Executor::Kinds::SINGLE
        @model.schedulable?.should be_false
      end
      it "should return true when kind is scheduled" do
        @model.kind = ActsAsExecutor::Executor::Kinds::SCHEDULED
        @model.schedulable?.should be_true
      end
      it "should return true when kind is single_scheduled" do
        @model.kind = ActsAsExecutor::Executor::Kinds::SINGLE_SCHEDULED
        @model.schedulable?.should be_true
      end
    end
    context "when invalid" do
      it "should return false when kind is nil" do
        @model.kind = nil
        @model.schedulable?.should be_false
      end
      it "should return false when kind is invalid" do
        @model.kind = "invalid"
        @model.schedulable?.should be_false
      end
    end
  end
end