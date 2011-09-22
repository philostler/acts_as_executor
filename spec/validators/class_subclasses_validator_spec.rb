require "spec_helper"

describe ClassSubclassesValidator do
  before(:each) { @model = ClassSubclassesValidator.new Hash[ :attributes => true, :superclass => Comparable ] }

  it { @model.should be_a ActiveModel::EachValidator }

  describe "#validate_each" do
    context "when class does not subclass" do
      it "should set error message" do
        attribute = "executable"
        record = double "Record"
        record.stub(:errors).and_return( { attribute => [] } )

        @model.validate_each record, attribute, "Object"

        record.errors[attribute].should include "does not subclass Comparable"
      end
    end
  end
end