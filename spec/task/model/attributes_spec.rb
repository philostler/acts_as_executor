require "spec_helper"

describe ActsAsExecutor::Task::Model::Attributes do
  before :each do
    @model = double_executor_task
  end

  describe "#future" do
    it "should not be accessible publicly" do
      expect { @model.future }.to raise_error NoMethodError
    end
    it "should be accessible via send method" do
      expect { @model.send :future }.to_not raise_error
    end
  end

  describe "#future=" do
    it "should not be accessible publicly" do
      expect { @model.future = nil }.to raise_error NoMethodError
    end
    it "should be accessible via send method" do
      expect {
        @model.id = 1
        @model.send :future=, nil
      }.to_not raise_error
    end
    it "should raise an error when id is nil" do
      expect { @model.send :future=, nil }.to raise_error ArgumentError, "cannot reference future against nil id"
    end
  end
end