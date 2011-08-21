Executor.blueprint do
  id        { "#{sn}" }
  name      { "name#{sn}" }
  max_tasks { 1 }
end

ExecutorTask.blueprint do
  id        { "#{sn}" }
  executor
  clazz     { "Clazz" }
  arguments { {:attribute_one => "attribute_one_value", :attribute_two => "attribute_two_value"} }
end

Clazz.blueprint do
  arguments { {:attribute_one => "attribute_one_value", :attribute_two => "attribute_two_value"} }
  object.stub :execute
end