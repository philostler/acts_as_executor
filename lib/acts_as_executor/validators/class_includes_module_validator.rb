class ClassIncludesModuleValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    begin
      throw TypeError unless Object.const_get(value).kind_of? options[:module]
    rescue NameError
    rescue TypeError
      record.errors[attribute] << "does not include module " + options[:module].to_s
    end
  end
end