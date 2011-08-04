require "spec_helper"

describe ClassIncludesModuleValidator do
  before(:each) { @model = ClassIncludesModuleValidator.new Hash[ :attributes => true, :module => Comparable ] }

  it { @model.should be_a ActiveModel::EachValidator }

  describe "#validate_each" do
    context "when class does not include module" do
      it "should set error message" do
        attribute = "clazz"
        record = double "Record"
        record.stub(:errors).and_return( { attribute => [] } )

        @model.validate_each record, attribute, "Object"

        record.errors[attribute].should include "does not include module Comparable"
      end
    end
  end
end