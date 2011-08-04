require "spec_helper"

describe ClassIncludesValidator do
  before(:each) { @model = ClassIncludesValidator.new Hash[ :attributes => true, :includes => Comparable ] }

  it { @model.should be_a ActiveModel::EachValidator }

  describe "#validate_each" do
    context "when class does not include" do
      it "should set error message" do
        attribute = "clazz"
        record = double "Record"
        record.stub(:errors).and_return( { attribute => [] } )

        @model.validate_each record, attribute, "Object"

        record.errors[attribute].should include "does not include Comparable"
      end
    end
  end
end