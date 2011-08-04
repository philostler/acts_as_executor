class ClassExistsValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    begin
      Object.const_get(value).new
    rescue NameError
      record.errors[attribute] << "does not exist as a Class"
    end
  end
end