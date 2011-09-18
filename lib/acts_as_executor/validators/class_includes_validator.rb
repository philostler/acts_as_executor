class ClassIncludesValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    begin
      unless Object.const_get(value).new.kind_of? options[:includes]
        record.errors[attribute] << "does not include " + options[:includes].to_s
      end
    rescue NameError
      # Ignore error if class does not exist.
    end
  end
end