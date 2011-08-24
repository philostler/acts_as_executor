RSpec::Matchers.define :allow_public_access_for_methods do |*methods|
  match_for_should do |object|
    responded_to_all = true
    methods.each do |method|
      responded_to_all = false unless object.respond_to? method
    end
    responded_to_all
  end

  match_for_should_not do |object|
    not_responded_to_all = true
    methods.each do |method|
      not_responded_to_all = false if object.respond_to? method
    end
    not_responded_to_all
  end
end

def log_statement executor_name, statement
  "\"" + executor_name + "\" " + statement
end

def log_message executor_name, doing, task_id, clazz_name, message = ""
  if message.kind_of? Hash then message = "with \"" + message.inspect + "\"" end 
  "\"" + executor_name + "\" " + doing + " \"" + task_id + "#" + clazz_name + "\" " + message
end