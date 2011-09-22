class ClassSubclassesValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    begin
      unless Object.const_get(value).new.kind_of? options[:superclass]
        record.errors[attribute] << "does not subclass " + options[:superclass].to_s
      end
    rescue NameError
      # Ignore error if class does not exist.
    end
  end
end