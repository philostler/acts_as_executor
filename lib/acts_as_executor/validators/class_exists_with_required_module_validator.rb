class ClassExistsWithRequiredModuleValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    begin
      instance = Object.const_get(value).new
      throw TypeError unless instance.kind_of? ActsAsExecutor::Task::Clazz
    rescue NameError
      record.errors[attribute] << "does not exist as a Class"
    rescue TypeError
      record.errors[attribute] << "does not include required Module"
    end
  end
end