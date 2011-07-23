Executor.blueprint do
  id   { "#{sn}" }
  name { "name#{sn}" }
  kind { ActsAsExecutor::Executor::Kinds::SINGLE }
end

ExecutorTask.blueprint do
  id   { "#{sn}" }
end

Clazz.blueprint do
  arguments { {:attribute_one => "attribute_one_value", :attribute_two => "attribute_two_value"} }
  object.stub :execute
end