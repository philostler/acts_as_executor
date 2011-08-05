class ClassIncludesValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    begin
      throw TypeError unless Object.const_get(value).new.kind_of? options[:includes]
    rescue NameError
    rescue TypeError
      record.errors[attribute] << "does not include " + options[:includes].to_s
    end
  end
end