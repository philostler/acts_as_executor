require "spec_helper"

describe ClassExistsValidator do
  before(:each) { @model = ClassExistsValidator.new Hash[ :attributes => true ] }

  it { @model.should be_a ActiveModel::EachValidator }

  describe "#validate_each" do
    context "when class does not exist" do
      it "should set error message" do
        attribute = "clazz"
        record = double "Record"
        record.stub(:errors).and_return( { attribute => [] } )

        @model.validate_each record, attribute, "NonexistentClass"

        record.errors[attribute].should include "does not exist as a Class"
      end
    end
  end
end