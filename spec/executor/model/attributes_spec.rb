require "spec_helper"

describe ActsAsExecutor::Executor::Model::Attributes do
  before :each do
    @model = Executor.new
  end

  describe "#executor" do
    it "should not be accessible publicly" do
      expect { @model.executor }.to raise_error NoMethodError
    end
    it "should be accessible via send method" do
      expect { @model.send :executor }.to_not raise_error
    end
  end

  describe "#executor=" do
    it "should not be accessible publicly" do
      expect { @model.executor = nil }.to raise_error NoMethodError
    end
    it "should be accessible via send method" do
      expect {
        @model.id = 1
        @model.send :executor=, nil
      }.to_not raise_error
    end
    it "should raise an error when id is nil" do
      expect { @model.send :executor=, nil }.to raise_error ArgumentError, "cannot reference executor against nil id"
    end
  end

  describe "#log" do
    it "should not be accessible publicly" do
      expect { @model.log }.to raise_error NoMethodError
    end
    it "should be accessible via send method" do
      expect { @model.send :log }.to_not raise_error
    end
  end

  describe "#logger" do
    it "should not be accessible publicly" do
      expect { @model.logger }.to raise_error NoMethodError
    end
    it "should be accessible via send method" do
      expect { @model.send :logger }.to_not raise_error
    end
  end
end